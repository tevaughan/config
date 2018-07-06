# $Id$

import email, email.Generator, email.Parser, email.Errors
import mailbox, nntplib, os, re, tempfile, time, urllib
from muttils import pybrowser, util, wget

def _makequery(mid):
    '''Reformats Message-ID to google query.'''
    ggroups = 'http://groups.google.com/groups'
    query = {'selm': mid}
    return '%s?%s' % (ggroups,  urllib.urlencode(query))

def _getraw(msgurl):
    query = {'dmode': 'source', 'output': 'gplain'}
    return '%s?%s' % (msgurl, urllib.urlencode(query))

def _msgfactory(fp):
    try:
        p = email.Parser.HeaderParser()
        return p.parse(fp, headersonly=True)
    except email.Errors.HeaderParseError:
        return ''

def _getmhier():
    castle = os.environ['HOME']
    for md in ('Maildir', 'Mail'):
        d = os.path.join(castle, md)
        if os.path.isdir(d):
            return [d]
    return []

def _getmspool():
    '''Tries to return a sensible default for user's mail spool.'''
    mailspool = os.getenv('MAIL', '')
    if not mailspool:
        ms = os.path.join('var', 'mail', os.environ['USER'])
        if os.path.isfile(ms):
            return ms
    elif mailspool.endswith(os.sep):
        return mailspool[:-1] # ~/Maildir/-INBOX[/]
    return mailspool

def _mkunixfrom(msg):
    if msg['return-path']:
        ufrom = msg['return-path'][1:-1]
    else:
        ufrom = email.Utils.parseaddr(msg.get('from', 'nobody'))[1]
    msg.set_unixfrom('From %s  %s' % (ufrom, time.asctime()))
    return msg


class kiosk(object):
    '''
    Provides methods to search for and retrieve
    messages via their Message-ID.
    '''
    mspool = ''         # path to local mail spool
    msgs = []           # list of retrieved message objects
    muttone = True      # configure mutt for display of 1 msg only
    mdmask = '^(cur|new|tmp)$'

    def __init__(self, ui, items=None):
        self.ui = ui
        self.items = items or []

    def kiosktest(self):
        '''Provides the path to an mbox file to store retrieved messages.'''
        if not self.ui.kiosk:
            self.ui.kiosk = tempfile.mkstemp(prefix='kiosk.')[1]
            return
        self.ui.kiosk = util.absolutepath(self.ui.kiosk)
        if (not os.path.exists(self.ui.kiosk) or
            not os.path.getsize(self.ui.kiosk)):
            # non existant or empty is fine
            return
        if not os.path.isfile(self.ui.kiosk):
            raise util.DeadMan('%s: not a regular file' % self.ui.kiosk)
        fp = open(self.ui.kiosk, 'rb')
        try:
            testline = fp.readline()
        finally:
            fp.close()
        try:
            p = email.Parser.Parser()
            check = p.parsestr(testline, headersonly=True)
        except email.Errors.HeaderParseError, inst:
            raise util.DeadMan(inst)
        if check.get_unixfrom():
            self.muttone = False
        else:
            raise util.DeadMan('%s: not a unix mailbox' % self.ui.kiosk)

    def getmhiers(self):
        '''Checks whether given directories exist and
        creates mhiers set (unique elems) with absolute paths.'''
        if self.ui.mhiers or self.ui.specdirs: # cmdline priority
            # specdirs have priority
            mhiers = self.ui.specdirs or self.ui.mhiers
            # split colon-separated list from cmdline
            mhiers = mhiers.split(':')
        elif self.ui.mhiers is None:
            mhiers = self.ui.configlist('messages', 'maildirs',
                                        default=_getmhier())
        else:
            mhiers = self.ui.mhiers
        # create set of unique elements
        mhiers = set([util.absolutepath(e) for e in mhiers])
        mhiers = sorted(mhiers)
        self.ui.mhiers = []
        previtem = ''
        for hier in mhiers:
            if not os.path.isdir(hier):
                self.ui.warn('%s: not a directory, skipping\n' % hier)
                continue
            if previtem and hier.startswith(previtem):
                self.ui.warn('%s: subdirectory of %s, skipping\n'
                             % (hier, previtem))
                continue
            self.ui.mhiers.append(hier)
            previtem = hier

    def goobrowse(self):
        '''Visits given urls with browser and exits.'''
        items = map(_makequery, self.items)
        b = pybrowser.browser(parentui=self.ui, items=items)
        b.urlvisit()

    def gogoogle(self):
        '''Gets messages from Google Groups.'''
        self.ui.note('note: google masks all email addresses\n',
                     'going google ...\n')
        uget = wget.wget(self.ui, ('User-Agent', 'w3m'))
        for mid in self.items[:]:
            msgurl = uget.request(_makequery(mid), 'g')
            if msgurl:
                msg = uget.request(_getraw(msgurl))
                if msg and msg.split('\n', 1)[1].find('DOCTYPE html') == -1:
                    msg = email.message_from_string(msg)
                    self.msgs.append(msg)
                    self.items.remove(mid)
                else:
                    self.ui.warn('%s: not found at google\n' % mid)

    def newssearch(self, sname):
        '''Retrieves messages from newsserver.'''
        self.ui.note('searching news server %s\n' % sname)
        try:
            nserv = nntplib.NNTP(sname, readermode=True, usenetrc=True)
        except (nntplib.NNTPPermanentError, nntplib.NNTPTemporaryError):
            try:
                nserv = nntplib.NNTP(sname, readermode=True, usenetrc=False)
            except (nntplib.NNTPPermanentError,
                    nntplib.NNTPTemporaryError), inst:
                self.ui.warn('%s\n' % inst)
                return
        for mid in self.items[:]:
            try:
                art = nserv.article('<%s>' % mid)
                art = '\n'.join(art[-1]) + '\n'
                self.msgs.append(email.message_from_string(art))
                self.items.remove(mid)
            except nntplib.NNTPTemporaryError:
                pass
        nserv.quit()
        if self.items:
            self.ui.note('%s not on server %s\n' %
                         (util.plural(len(self.items), 'message'), sname))

    def boxparser(self, path, maildir=False, isspool=False):
        if (not isspool and path == self.mspool or
            self.ui.mask and self.ui.mask.search(path) is not None):
            return
        if maildir:
            try:
                dl = os.listdir(path)
            except OSError:
                return
            for d in 'cur', 'new', 'tmp':
                if d not in dl:
                    return
            mbox = mailbox.Maildir(path, _msgfactory)
        else:
            try:
                fp = open(path, 'rb')
            except IOError, inst:
                self.ui.warn('%s\n' % inst)
                return
            mbox = mailbox.PortableUnixMailbox(fp, _msgfactory)
        self.ui.note('searching %s ' % path)
        while True:
            try:
                msg = mbox.next()
                self.ui.write('.')
                self.ui.flush()
            except IOError, inst:
                self.ui.warn('\n%s\n' % inst)
                break
            if msg is None:
                self.ui.write('\n')
                break
            msgid = msg.get('message-id', '').strip('<>')
            if msgid in self.items:
                self.msgs.append(msg)
                self.items.remove(msgid)
                self.ui.note('\nretrieving Message-ID <%s>\n' % msgid)
                if not self.items:
                    break
        if not maildir:
            fp.close()

    def walkmhier(self, mdir):
        '''Visits mail hierarchies and parses their mailboxes.
        Detects mbox and Maildir mailboxes.'''
        for root, dirs, files in os.walk(mdir):
            if not self.items:
                break
            rmdl = [d for d in dirs if self.mdmask.search(d) is not None]
            for d in rmdl:
                dirs.remove(d)
            for name in dirs:
                if self.items:
                    path = os.path.join(root, name)
                    self.boxparser(path, True)
            for name in files:
                if self.items:
                    path = os.path.join(root, name)
                    self.boxparser(path)

    def mailsearch(self):
        '''Announces search of mailboxes, searches spool,
        and passes mail hierarchies to walkmhier.'''
        self.ui.note('Searching local mailboxes ...\n')
        if not self.ui.specdirs: # include mspool
            self.mspool = _getmspool()
            if self.mspool:
                self.boxparser(self.mspool,
                               os.path.isdir(self.mspool), isspool=True)
        self.mdmask = re.compile(r'%s' % self.mdmask)
        for mhier in self.ui.mhiers:
            self.walkmhier(mhier)

    def maskompile(self):
        try:
            self.ui.mask = re.compile(r'%s' % self.ui.mask)
        except re.error, inst:
            raise util.DeadMan("%s in pattern `%s'" % (inst, self.ui.mask))

    def openkiosk(self, firstid):
        '''Opens mutt on kiosk mailbox.'''
        fp = open(self.ui.kiosk, 'ab')
        try:
            g = email.Generator.Generator(fp, maxheaderlen=0)
            for msg in self.msgs:
                # delete read status and local server info
                for h in ('status', 'xref'):
                    del msg[h]
                if not msg.get_unixfrom():
                    msg = _mkunixfrom(msg)
                g.flatten(msg, unixfrom=True)
        finally:
            fp.close()
        mailer = self.ui.configitem('messages', 'mailer', default='mutt')
        cs = [mailer]
        if mailer[:4] == 'mutt':
            if len(self.msgs) == 1 and self.muttone:
                cs += ["-e", "'set pager_index_lines=0'",
                       "-e", "'set quit=yes'", "-e", "'bind pager q quit'",
                       "-e", "'push <return>'"]
            else:
                cs += ["-e", "'set uncollapse_jump'",
                       "-e" "'push <search>~i\ \'%s\'<return>'" % firstid]
        cs += ['-f', self.ui.kiosk]
        util.systemcall(cs)

    def plainkiosk(self):
        self.kiosktest()
        itemscopy = self.items[:]
        # news search is very fast, so always try it first
        self.newssearch(os.environ.get('NNTPSERVER') or 'localhost')
        if self.items and not self.ui.news:
            if not self.ui.local:
                # try mail2news gateway
                self.newssearch('news.gmane.org')
            if self.items:
                self.getmhiers()
                if self.ui.mask:
                    self.maskompile()
                self.mailsearch()
                if self.items:
                    self.ui.note('%s not in specified local mailboxes\n' %
                                 util.plural(len(self.items), 'message'))
        if not self.ui.local:
            for nserv in self.ui.configlist('net', 'newsservers'):
                if self.items:
                    self.newssearch(nserv)
            if self.items:
                self.gogoogle()
        elif self.items:
            time.sleep(3)
        if self.msgs:
            firstid = None
            for mid in itemscopy:
                if mid not in self.items:
                    firstid = mid
                    break
            self.openkiosk(firstid)

    def kioskstore(self):
        '''Collects messages identified by ID either
        by retrieving them locally or from GoogleGroups.'''
        if self.ui.browse:
            self.goobrowse()
        else:
            self.plainkiosk()

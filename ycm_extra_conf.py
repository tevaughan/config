
"""
Define a global function, FlagsForFile, for use with youcompleteme.

FlagsForFile takes a filename and another, mysterious argument and returns a
dictionary with a 'flags' key and a 'do_cache' key.  The latter refers to a
boolean value.

The present file is meant to be a top-level, default config file that sits at
the top of the user's home directory.  A project-specific version of this file
might have a customized set of '-I' entries.
"""

import os

# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
FLAGS = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    #'-DNDEBUG',

    # THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know
    # which language to use when compiling headers.  ALWAYS specify a
    # "-std=<something>".  For a C project, you would set this to something
    # like 'c99' instead of 'c++11'.
    '-std=c++17',

    # ...and the same thing goes for the magic -x option which specifies the
    # language that the files to be compiled are written in.  This is mostly
    # relevant for c++ headers.  For a C project, you would set this to 'c'
    # instead of 'c++'.
    '-x', 'c++',

    # In case user's home directory have an include subdirectory.
    '-I', 'include',

    # work-around from https://github.com/Valloric/YouCompleteMe/issues/2170
    #'-isystem', '/usr/include/c++/6',
    #'-isystem', '/usr/include/c++/6/backward',
    #'-isystem', '/usr/lib/clang/3.8.1/include',
    #'-isystem', '/usr/include',
    #'-isystem', '/usr/local/include',
]

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c']


def directory_of_this_script():
    """ Return directory containing present script. """
    return os.path.dirname(os.path.abspath(__file__))


def make_relative_paths_absolute(flags, working_directory):
    """
    Make every relative path in each element of the passed-in tuple, 'flags',
    be a relative path.
    """
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag
        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)
        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break
            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break
        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForFile(filename, **kwargs):
    """
    Function called by youcompleteme.

    The camel-case name for this function violates what pylint expects, but it
    seems required for proper functioning of youcompleteme.

    The arguments supplied by youcompleteme are ignored by the implementation
    here.
    """
    del filename, kwargs  # Delete unused arguments.
    relative_to = directory_of_this_script()
    final_flags = make_relative_paths_absolute(FLAGS, relative_to)
    return {'flags': final_flags, 'do_cache': True}

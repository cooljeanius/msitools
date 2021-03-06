dnl#                                               -*- Autoconf -*-
dnl# Process this file with autoconf to produce a configure script.

AC_INIT([msitools],[0.93],[https://bugzilla.gnome.org/enter_bug.cgi?product=msitools])
AC_PREREQ([2.69])
if test "x${VERSION}" = "x"; then
	test -z "${VERSION}" && export VERSION="`build-aux/git-version-gen .tarball-version`"
	AC_SUBST([VERSION])
fi

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_SRCDIR([libmsi/sql-parser.y])dnl

# Check what system this is:
AC_CANONICAL_TARGET
AS_CASE([$host],[*-*-mingw*|*-*-cygwin*],[win32=yes],[win32=no])
AM_CONDITIONAL([WIN32],[test $win32 = yes])
m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])
AM_MISSING_PROG([AUTOM4TE],[autom4te])dnl

# Automake
AM_INIT_AUTOMAKE([dejagnu foreign subdir-objects -Wno-portability dist-xz])
AM_MAINTAINER_MODE
AM_PROG_INSTALL_STRIP

# Checks specific to system
AC_OBJEXT
AC_EXEEXT
AC_USE_SYSTEM_EXTENSIONS

# Checks for programs.
AM_PROG_AR
if test "x${CC}" = "x"; then
	test -z "${CC}"
	AC_PROG_CC
else
	test ! -z "${CC}" && export CC
	AC_SUBST([CC])
fi
AC_PROG_CPP
AC_PROG_CXX
AM_PROG_LEX
AC_PROG_YACC
AC_PATH_PROG([UUID_BIN],[uuid])dnl

IT_PROG_INTLTOOL([0.35])dnl

# Checks for libraries.
AC_CHECK_LIB([c],[printf])
# FIXME: Replace `main' with a function in `-lmsi':
AC_CHECK_LIB([msi],[main])
# FIXME: Replace `main' with a function in `-lole32':
AC_CHECK_LIB([ole32],[main])dnl

AM_PATH_GLIB_2_0([2.12.0])
PKG_CHECK_MODULES([GOBJECT],[gobject-2.0 gio-2.0 >= 2.14])
PKG_CHECK_MODULES([GSF],[libgsf-1])dnl

# uuid-related checks
PKG_CHECK_MODULES([UUID],[uuid >= 1.4.1])
AC_SEARCH_LIBS([uuid_unparse_upper],[uuid])
AC_CHECK_LIB([uuid],[uuid_generate])
AC_CHECK_TYPES([uuid_t])
AC_CHECK_DECLS([uuid_t])
AC_CHECK_HEADER([uuid.h],[
  AC_DEFINE([HAVE_UUID_H],[1],[Define to 1 if you have the <uuid.h> header file.])
  ],[
  AC_CHECK_HEADER([ossp/uuid.h],[
    AC_DEFINE([HAVE_OSSP_UUID_H],[1],[Define to 1 if you have the <ossp/uuid.h> header file.])
  ],[],[#undef HAVE_UNISTD_H])
])
AC_CHECK_FUNCS([uuid_generate uuid_unparse_upper])
AC_CHECK_DECLS([uuid_generate])
AC_CHECK_DECLS([uuid_unparse_upper])dnl

# Libtool
LT_INIT([win32-dll static disable-fast-install])
LT_LANG([C])
LT_LANG([Windows Resource])
if test "x${RANLIB}" = "x"; then
	test -z "${RANLIB}"
	AC_PROG_RANLIB
else
	test ! -z "${RANLIB}" && export RANLIB
	AC_SUBST([RANLIB])
fi

# Gnome stuff
GOBJECT_INTROSPECTION_CHECK([0.9.4])
AM_CONDITIONAL([GIR],[test "x${INTROSPECTION_MAKEFILE}" != "x"])dnl

AM_PROG_VALAC([0.16])
AC_PATH_PROG([VAPIGEN],[vapigen],[no])
AC_SUBST([VAPIGEN])
AM_CONDITIONAL([VAPI],[test "x${VAPIGEN}" != "xno"])dnl

# Existing(?) Wixl
PKG_CHECK_MODULES([WIXL],[gio-2.0 >= 0.23.0
                          libgcab-1.0 >= 0.1.10
                          uuid >= 1.4.1
                          libxml-2.0 >= 2.7])dnl

# Gettext
GETTEXT_PACKAGE=msitools
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE],["${GETTEXT_PACKAGE}"],[Gettext Package])
AC_SUBST([GETTEXT_PACKAGE])
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.18.3])
AM_GLIB_GNU_GETTEXT

# Warnings
gl_MANYWARN_ALL_GCC([warnings])
nw=""
nw="${nw} -Wsystem-headers"            # Do NOT let system headers trigger warnings
nw="${nw} -Wundef"                   # All compiler preprocessors support #if UNDEF
nw="${nw} -Wtraditional"               # All compilers nowadays support ANSI C
nw="${nw} -Wstrict-overflow"           # yacc/bison generated code uses that...
nw="${nw} -Wconversion"          # These warnings usually do not point to mistakes.
nw="${nw} -Wsign-conversion"           # Likewise.
nw="${nw} -Wunused-parameter"          # Likewise.
nw="${nw} -Wunused-local-typedefs"     # Likewise.
nw="${nw} -Wunused-macros"             # Likewise.
nw="${nw} -Wunsafe-loop-optimizations" # Likewise.
nw="${nw} -Wabi"                       # Valid for C++/ObjC++ but not for C
nw="${nw} -Wdeprecated"                # Likewise.
nw="${nw} -Wuninitialized"            # Not supported if optimization is turned off
# Enable all GCC warnings not in this list.
gl_MANYWARN_COMPLEMENT([warnings],[${warnings}],[${nw}])
for w in ${warnings}; do
  gl_WARN_ADD([${w}])
done
gl_WARN_ADD([-Wno-sign-compare])
gl_WARN_ADD([-Wno-unused-parameter])
gl_WARN_ADD([-Wno-missing-field-initializers])dnl

# Checks for header files.
AC_HEADER_STDBOOL dnl# calls AC_CHECK_HEADER_STDBOOL
AC_CHECK_HEADERS([fcntl.h libintl.h libkern/i386/_OSByteOrder.h libmsi.h limits.h \
                  malloc.h malloc/malloc.h stddef.h stdio.h windows.h])dnl

if test "x${ac_cv_header_stdint_h}" = "x"; then
  test -z "${ac_cv_header_stdint_h}"
  AC_CHECK_HEADERS([stdint.h])
fi
if test "x${ac_cv_header_unistd_h}" = "x"; then
  test -z "${ac_cv_header_unistd_h}"
  AC_CHECK_HEADERS([unistd.h])
fi

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_BIGENDIAN
AC_C_INLINE
AC_C_PROTOTYPES
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_CHECK_SIZEOF([int])
AC_CHECK_ALIGNOF([int])
AC_CHECK_SIZEOF([long int])
AC_CHECK_ALIGNOF([long int])
AC_CHECK_TYPES([uustr])
AC_CHECK_TYPES([guint64])dnl

# Checks for library functions.
AC_FUNC_ALLOCA
AC_FUNC_MALLOC
AC_FUNC_MKTIME
AC_FUNC_REALLOC
AC_CHECK_FUNCS([fprintf memchr memmove memset mkdir rmdir select strcat strchr \
                strdup strtol])
AC_CHECK_DECLS([index])
AC_CHECK_DECLS([select])dnl

# Tests
AC_CONFIG_TESTDIR([.])
AC_CONFIG_FILES([atlocal])
AC_CONFIG_FILES([tests/package.m4.tmp:tests/package.m4.in],
[${srcdir}/build-aux/move-if-change tests/package.m4.tmp ${srcdir}/tests/package.m4
 cp ${srcdir}/tests/package.m4 tests/package.m4.tmp])dnl

AC_CONFIG_FILES([tools/msidump],[chmod +x tools/msidump])
AC_CONFIG_FILES([tools/msidiff],[chmod +x tools/msidiff])
AC_CONFIG_FILES([
    Makefile
    include/Makefile
    data/Makefile
    po/Makefile.in
    libmsi/Makefile
    libmsi/libmsi-1.0.pc
    tests/Makefile
])
AC_OUTPUT

AC_MSG_NOTICE([
        msitools ${VERSION}
        ================

        prefix:                   ${prefix}
        c compiler:               ${CC}
        c flags:                  ${CFLAGS}
])dnl

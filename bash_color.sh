\[\e]2;\u@\H \w\a${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$

# Fix for:
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
#    LANGUAGE = (unset),
#    LC_ALL = (unset),
#    LANG = "en_US.UTF-8"
# are supported and installed on your system.
# perl: warning: Falling back to the standard locale ("C").
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LC_TYPE=en_US.UTF-8

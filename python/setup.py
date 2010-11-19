from distutils.core import setup
setup(name='ip2something',
      version='0.2',
      package_dir={'': 'src'},
      url='http://github.com/athoune/ip2something',
      scripts=['bin/ip2db', 'bin/ip2pipe'],
      py_modules=['ip2something'],
      )
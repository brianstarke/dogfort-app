dogfort-app
===========

### rebuild app

The jade, less, and coffeescript are compiled by [gulp](https://github.com/gulpjs/gulp) and copied to the ```public/``` folder.

You'll need [node](http://nodejs.org/), [gulp](https://github.com/gulpjs/gulp), and [bower](http://bower.io/).

```
cd app
npm install -g gulp
npm install -g bower
npm install
gulp --require coffee-script/register build
```

That will create the ```public/``` folder which can be served by Martini by the [dogfort server](https://github.com/brianstarke/dogfort)

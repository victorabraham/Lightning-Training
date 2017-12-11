var gulp = require('gulp');
var forceDeploy = require('gulp-jsforce-deploy');
var zip = require('gulp-zip');
var builder = require('xmlbuilder');
var fs = require('fs');
var path = require('path');

//Base folder name if there is one. If not use './' instead;
const baseFolder = './src/';
const ignoreContent = fs.readFileSync('./.gitignore', 'utf8');

//Task for generating package.xml
gulp.task('buildPackageXml', function(cb){
    var packageObj = {};
    packageObj.Package = {
                            '@xmlns': 'http://soap.sforce.com/2006/04/metadata',
                            types: [ generateXmlSection(baseFolder+'classes/','.cls','ApexClass'),
                                     generateXmlSection(baseFolder+'components/','.cmp','ApexComponent'),
                                     generateXmlSection(baseFolder+'pages/','.page','ApexPage'),
                                     generateXmlSection(baseFolder+'flexipages/','.flexipage','FlexiPage'),
                                     generateXmlSection(baseFolder+'triggers/','.trigger','ApexTrigger'),
                                     generateXmlSection(baseFolder+'staticresources/','.resource','StaticResource'),
                                     generateXmlSection(baseFolder+'objects/','.object','CustomObject'),
                                     generateXmlSection(baseFolder+'layouts/','.layout','Layout'),
                                     generateXmlSection(baseFolder+'tabs/','.tab','CustomTab'),
                                     generateXmlSection(baseFolder+'flows/','.flow','Flow'),
                                     generateXmlSection(baseFolder+'applications/','.app','CustomApplication'),
                                     generateAuraSection(baseFolder+'aura/','AuraDefinitionBundle'),
                                     generateCustomMetadataSection(baseFolder+'customMetadata/','CustomMetadata')
                                   ],
                            version:'36.0'
                         } 
    //Removing empty type sections from package.xml
    packageObj.Package.types = packageObj.Package.types.filter(function(val){
        return val;
    });
    var root = builder.create(packageObj);
    fs.writeFileSync(baseFolder+'package.xml', '<?xml version="1.0" encoding="UTF-8"?>'+root.toString());
    return gulp.src(baseFolder+'package.xml');
});

//Function for generating particular section of package.xml
function generateXmlSection(basePath, extension, typeVal){
    if (!fs.existsSync(basePath)) {
        return '';
    }
    var typeObj = {};
    //Removing extensions
    var memberArray = fs.readdirSync(basePath).map(function(val){
        //Checking if the file is ignored
        if(ignoreContent.indexOf((basePath+val).substring(1)) === -1){
            if(val.match(extension+"$") == extension){
                val = val.substring(0, val.length - extension.length);
                return val;
            }else{
                return null;
            }
        }else{
            return null;
        }
    });
    //Removing empty elements;
    memberArray = memberArray.filter(function(val){
        return val;
    });
    typeObj.members = memberArray;
    typeObj.name = typeVal;
    return typeObj;
}

//Function for generating aura section of package.xml
function generateAuraSection(basePath,typeVal){
    if (!fs.existsSync(basePath)) {
        return '';
    }
    var typeObj = {};
    typeObj.members = fs.readdirSync(basePath).filter(function(file) {
        return fs.statSync(path.join(basePath, file)).isDirectory();
    });
    typeObj.name = typeVal;
    return typeObj;
}

//Function for generating custom metadata section of package.xml
function generateCustomMetadataSection(basePath, typeVal) {
    if (!fs.existsSync(basePath)) {
        return '';
    }
    var typeObj = {};
    typeObj.members = '*';
    typeObj.name = typeVal;
    return typeObj;
}

//Task to deploy the changes to Salesforce
gulp.task('deployToSF',['buildPackageXml'], function (cb) {
    var gulpFolder = baseFolder;
    //removing ./ from start of the path and / form end for gulp
    gulpFolder = gulpFolder.replace(/^\.\//,'');
    gulpFolder = gulpFolder.replace(/\/$/,'');
    return gulp.src(gulpFolder+'*/**/*')
        .pipe(zip('package.zip'))
        .pipe(gulp.dest('./'))
        .pipe(forceDeploy({
            username: process.env.SF_USERNAME,
            password: process.env.SF_PASSWORD,
            loginUrl: 'https://login.salesforce.com'
                , pollTimeout: 10*60*1000
                , version: '36.0'
                //, pollInterval: 10*1000
        }));
});
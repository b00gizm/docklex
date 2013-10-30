<?php

require_once __DIR__.'/../vendor/autoload.php';

$app = new Silex\Application();

if ('dev' == getenv('SILEX_ENV')) {
    $app['debug'] = true;
}

$app->get('/', function() {

    return "Hello from Docklex!";

});

$app->run();

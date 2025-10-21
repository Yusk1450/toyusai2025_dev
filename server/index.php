<?php

ini_set('display_errors', 1);

use Slim\Factory\AppFactory;

require_once("vendor/autoload.php");

$app = AppFactory::create();

$env = file_get_contents('.env');
$env = json_decode($env, true);

if ($env['mode'] == 'debug')
{
	$app->setBasePath($env['basePath']);
}

$flag_filename = 'flag.json';

function load_flags()
{
	global $flag_filename;
	return json_decode(file_get_contents($flag_filename), true);
}

function save_flags($data)
{
	global $flag_filename;
	file_put_contents($flag_filename, json_encode($data, JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT));
}

/* -----------------------------------------------------
 * フラグをリセットする
----------------------------------------------------- */
$app->get('/reset', function ($req, $res, $args)
{
	$data = load_flags();

	foreach ($data as &$item)
	{
		$item['clear'] = false;
	}

	save_flags($data);

	$resBody = $res->getBody();
	$resBody->write('ok');

	return $res;
});

/* -----------------------------------------------------
 * 現在のフラグを取得する
----------------------------------------------------- */
$app->get('/flag', function ($req, $res, $args)
{
	$data = load_flags();

	$result = array();
	foreach ($data as &$item)
	{
		$result []= $item['clear'];
	}

	$resBody = $res->getBody();
	$resBody->write(json_encode($result));

	return $res;
});

/* -----------------------------------------------------
 * フラグを立てる
----------------------------------------------------- */
$app->post('/flag', function ($req, $res, $args)
{
	$params = $req->getParsedBody();

	$data = load_flags();

	$data[intval($params['flag_id'])]['clear'] = true;
	save_flags($data);

	$result = array();
	foreach ($data as &$item)
	{
		$result []= $item['clear'];
	}

	$resBody = $res->getBody();
	$resBody->write(json_encode($result));

	return $res;
});


$app->run();

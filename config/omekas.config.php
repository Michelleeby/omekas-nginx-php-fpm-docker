<?php
return [
    'logger' => [
        'log' => false,
        'priority' => \Laminas\Log\Logger::NOTICE,
    ],
    'http_client' => [
        'sslcapath' => null,
        'sslcafile' => null,
    ],
    'cli' => [
        'phpcli_path' => null,
    ],
    'thumbnails' => [
        'types' => [
            'large' => [
                'constraint' => 800,
                'options' => [ 'gravity' => 'center' ],
            ],
            'medium' => [
                'constraint' => 400, 
                'options' => [ 'gravity' => 'center' ], 
            ],
            'square' => [
                'constraint' => 200,
                'options' => [ 'gravity' => 'center' ],
            ],
        ],
        'thumbnailer_options' => [
            'imagemagick_dir' => null,
            'vips_dir' => null,
        ],
    ],
    'translator' => [
        'locale' => 'en_US',
    ],
    'service_manager' => [
        'aliases' => [
            'Omeka\File\Store' => 'Omeka\File\Store\Local',
            'Omeka\File\Thumbnailer' => 'Omeka\File\Thumbnailer\Vips',
        ],
    ],
];

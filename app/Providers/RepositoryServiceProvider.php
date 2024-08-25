<?php

namespace App\Providers;

use App\Repositories\AbstractAppRepository;
use App\Repositories\AppRepositoryInterface;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    protected array $services = [
        AppRepositoryInterface::class => AbstractAppRepository::class,
    ];
    /**
     * Register services.
     */
    public function register(): void
    {
        foreach ($this->services as $abstract => $concrete) {
            $this->app->bind($abstract, $concrete);
        }
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}

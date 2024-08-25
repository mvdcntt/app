<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Model;

abstract class AbstractAppRepository implements AppRepositoryInterface
{
    protected Model $model;

    abstract public function getModel(): Model;
}

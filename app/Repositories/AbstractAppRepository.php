<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

abstract class AbstractAppRepository implements AppRepositoryInterface
{
    protected Model $model;

    abstract public function getModel(): Model;

    public function __construct() {
        $this->model = $this->getModel();
    }

    public function find(int $id, array $columns = ['*']): ?Model
    {
        return $this->model->find($id, $columns);
    }

    public function all(array $columns = ['*']): Collection
    {
        return $this->model->all($columns);
    }

    public function create(array $attributes): ?Model
    {
        return $this->model->store($attributes);
    }

    public function update(int $id, array $attributes): ?bool
    {
        return $this->model->update($id, $attributes);
    }

    public function delete(int $id): bool
    {
        return $this->model->destroy($id);
    }
}

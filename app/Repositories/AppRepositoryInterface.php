<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

interface AppRepositoryInterface
{
    public function all(array $columns = ['*']): Collection;

    public function find(int $id, array $columns = ['*']): ?Model;

    public function create(array $attributes): ?Model;

    public function update(int $id, array $attributes): ?bool;

    public function delete(int $id): bool;


}

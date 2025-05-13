<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $fillable = ['title', 'completed'];
    
    public function test_homepage_laadt()
{
    // 1. Maak testdata aan
    Task::create(['title' => 'Test Taak', 'completed' => false]);

    // 2. Laad de pagina
    $response = $this->get('/');

    // 3. Controleer of het werkt
    $response->assertStatus(200);
    $response->assertSee('Test Taak');
}
}


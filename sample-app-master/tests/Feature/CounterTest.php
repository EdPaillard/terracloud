<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class CounterTest extends TestCase
{
    /**
     * A basic feature test example.
     *
     * @return void
     */
    public function getCounter()
    {
        $response = $this->get('/api/counter/count');

        $response->assertStatus(200);
    }

    /** @test */
    public function getCounterValue()
    {
        $response = $this->get('/api/counter/count');

        $response->assertJsonStructure(['value']);
    }

    /** @test */
    public function addCounter()
    {
        $response = $this->get('/api/counter/add');

        $response->assertStatus(200);
    }

    /** @test */
    public function addCounterValue()
    {
        $response = $this->get('/api/counter/add');

        $response->assertJsonStructure(['value']);
    }
}

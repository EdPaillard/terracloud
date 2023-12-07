<?php

namespace App\Http\Controllers;

use App\Models\Counter;

class CounterController extends Controller
{
    public function add()
    {
        $counter = new Counter();
        $counter->count = 1;
        $counter->save();
        $value = Counter::sum('count');
        return response()->json(["value" => $value], 200);
    }

    public function get()
    {
        $value = Counter::sum('count');
        return response()->json(["value" => $value], 200);
    }
}

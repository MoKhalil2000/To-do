<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>To-Do App</title>
    @vite('resources/css/app.css')
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-6">
    <div class="bg-white shadow-xl rounded-lg w-full max-w-md p-6">
        <h1 class="text-2xl font-bold mb-4 text-center">📝 To-Do App</h1>

        {{-- Form: Toevoegen of Bewerken --}}
        @if (isset($task))
            <form action="/tasks/{{ $task->id }}" method="POST" class="flex gap-2 mb-4">
                @csrf
                @method('PATCH')
                <input 
                    type="text" 
                    name="title" 
                    value="{{ $task->title }}" 
                    required
                    class="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-400"
                >
                <button 
                    type="submit" 
                    class="bg-yellow-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-600"
                >
                    Bijwerken
                </button>
                <a href="/" class="px-4 py-2 rounded-lg bg-gray-300 hover:bg-gray-400">Annuleer</a>
            </form>
        @else
            <form action="/tasks" method="POST" class="flex gap-2 mb-4">
                @csrf
                <input 
                    type="text" 
                    name="title" 
                    placeholder="Nieuwe taak..." 
                    required
                    class="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
                >
                <button 
                    type="submit" 
                    class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600"
                >
                    Toevoegen
                </button>
            </form>
        @endif

        {{-- Takenlijst --}}
        <ul>
            @forelse ($tasks as $item)
                <li class="flex items-center justify-between border-b py-2">
                    <div class="flex items-center gap-2">
                        {{-- Voltooien --}}
                        <form action="/tasks/{{ $item->id }}" method="POST">
                            @csrf
                            @method('PATCH')
                            <button type="submit" class="text-xl">
                                @if ($item->completed)
                                    ✅
                                @else
                                    ⬜
                                @endif
                            </button>
                        </form>

                        {{-- Titel --}}
                        <span class="{{ $item->completed ? 'line-through text-gray-500' : '' }}">
                            {{ $item->title }}
                        </span>
                    </div>

                    <div class="flex items-center gap-2">
                        {{-- Bewerken --}}
                        <a 
                            href="/tasks/{{ $item->id }}/edit" 
                            class="text-yellow-500 hover:text-yellow-700 text-lg"
                        >
                            ✏️
                        </a>

                        {{-- Verwijderen --}}
                        <form action="/tasks/{{ $item->id }}" method="POST">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-500 hover:text-red-700 text-lg">🗑</button>
                        </form>
                    </div>
                </li>
            @empty
                <li class="text-gray-500 text-center py-4">Nog geen taken.</li>
            @endforelse
        </ul>
    </div>
    
</body>
@if (app()->environment() !== 'testing')
    <script src="{{ mix('/js/app.js') }}"></script>
    <link href="{{ mix('/css/app.css') }}" rel="stylesheet">
@endif

</html>

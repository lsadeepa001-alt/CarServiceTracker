<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SwiftDrive Services | Home</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,500;14..32,600;14..32,700&display=swap"
        rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .hero-overlay {
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(2px);
        }
    </style>
</head>

<body class="relative min-h-screen flex items-center justify-center bg-gray-900">

    <div class="absolute inset-0 bg-cover bg-center bg-no-repeat z-0"
        style="background-image: url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1983&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');">
        <div class="absolute inset-0 bg-black/40"></div>
    </div>

    <div class="relative z-10 w-full max-w-4xl px-4">
        <div class="bg-white/80 backdrop-blur-sm rounded-2xl p-8 md:p-10 shadow-xl text-center">

            <h1
                class="text-4xl sm:text-5xl md:text-6xl font-bold bg-gradient-to-r from-blue-700 to-indigo-800 bg-clip-text text-transparent">
                SwiftDrive Services
            </h1>

            <p class="mt-4 text-lg sm:text-xl md:text-2xl text-gray-700 font-light max-w-2xl mx-auto">
                Effortless vehicle history, right at your fingertips.
            </p>

            <div class="my-8 flex justify-center items-center gap-3">
                <span class="h-0.5 w-12 bg-blue-200 rounded-full"></span>
                <span class="text-blue-400 font-medium text-sm tracking-wider">DRIVE | TRACK | SHINE</span>
                <span class="h-0.5 w-12 bg-blue-200 rounded-full"></span>
            </div>

            <p class="text-gray-600 text-base md:text-lg mb-8 max-w-xl mx-auto">
                Welcome! Seamlessly manage maintenance, repairs, and service records - all in one place.
            </p>

            <div class="mt-6 flex flex-row items-center justify-center gap-2">
                <a href="login.jsp"
                    class="group w-full sm:w-auto px-8 py-4 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-semibold rounded-xl shadow-lg hover:shadow-2xl hover:scale-[1.02] transform transition-all duration-300 focus:ring-4 focus:ring-blue-300 flex items-center justify-center gap-3 text-sm sm:text-md lg:text-lg">
                    <svg xmlns="http://www.w3.org/2000/svg"
                        class="h-5 w-5 transition-transform group-hover:translate-x-0.5" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                    </svg>
                    Login
                </a>
                <a href="register.jsp"
                    class="group w-full sm:w-auto px-8 py-4 bg-white/80 backdrop-blur-sm border-2 border-indigo-200 text-indigo-700 font-semibold rounded-xl hover:bg-white hover:border-indigo-300 shadow-md hover:shadow-xl transform transition-all duration-300 focus:ring-4 focus:ring-indigo-200 flex items-center justify-center gap-3 text-sm sm:text-md lg:text-lg">
                    <svg xmlns="http://www.w3.org/2000/svg"
                        class="h-5 w-5 text-indigo-500 group-hover:scale-110 transition-transform" fill="none"
                        viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                    </svg>
                    Register
                </a>
            </div>
        </div>
    </div>

    <div
        class="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-blue-400 to-transparent z-20">
    </div>

</body>

</html>
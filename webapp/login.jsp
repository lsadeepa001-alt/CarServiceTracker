<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SwiftDrive Services</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1983&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }
        .overlay {
            background: linear-gradient(135deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.5) 100%);
            backdrop-filter: blur(3px);
        }
    </style>
</head>
<body class="relative">
    <!-- Dark overlay layer -->
    <div class="overlay fixed inset-0"></div>
    
    <div class="relative min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8 bg-white/95 backdrop-blur-sm p-10 rounded-2xl shadow-2xl border border-white/20">
            <div class="text-center">
                <h2 class="text-4xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">Welcome Back</h2>
                <p class="mt-3 text-sm text-gray-600">Sign in to your SwiftDrive account</p>
            </div>
            
            <form action="LoginServlet" method="POST" class="mt-8 space-y-6">
                <div class="space-y-5">
                    <div>
                        <label for="username" class="block text-sm font-semibold text-gray-700 mb-2">Username</label>
                        <div class="relative">
                            <input 
                                id="username"
                                name="username" 
                                type="text" 
                                required 
                                class="appearance-none relative block w-full pl-2 py-3 border-2 border-gray-200 placeholder-gray-400 text-gray-900 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 sm:text-sm"
                                placeholder="Enter your username"
                            >
                        </div>
                    </div>
                    
                    <div>
                        <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">Password</label>
                        <div class="relative">
                            <input 
                                id="password"
                                name="password" 
                                type="password" 
                                required 
                                class="appearance-none relative block w-full pl-2 py-3 border-2 border-gray-200 placeholder-gray-400 text-gray-900 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 sm:text-sm"
                                placeholder="Enter your password"
                            >
                        </div>
                    </div>
                </div>

                <div class="flex flex-col space-y-3">
                    <button 
                        type="submit" 
                        class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-semibold rounded-xl text-white bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transform transition-all duration-200 hover:scale-[1.02] shadow-lg"
                    >
                        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                            <svg class="h-5 w-5 text-blue-300 group-hover:text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                            </svg>
                        </span>
                        Sign In
                    </button>

                    <div class="text-sm text-center text-gray-600">
                        Don't have an account? 
                        <a href="register.jsp" class="font-semibold text-blue-600 hover:text-blue-500 hover:underline transition-colors duration-200">
                            Register here
                        </a>
                    </div>
                    
                    <a 
                        href="index.jsp" 
                        class="text-center text-sm text-gray-500 hover:text-gray-700 hover:underline flex items-center justify-center gap-1 transition-colors duration-200"
                    >
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                        </svg>
                        Back to Home
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
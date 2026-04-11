<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<div id="toast-container" class="fixed top-5 right-5 z-50 flex flex-col gap-3 pointer-events-none"></div>

<script>
    function showToast(message, type) {
        if (!type) type = 'success';
        var container = document.getElementById('toast-container');
        
        var toast = document.createElement('div');
        var isError = type === 'error';
        var bgColor = isError ? 'bg-red-600' : 'bg-emerald-600';
        var icon = isError ? '<i class="fa-solid fa-circle-exclamation"></i>' : '<i class="fa-solid fa-circle-check"></i>';
        var title = isError ? 'Error!' : 'Success!';
        
        toast.className = "flex items-start w-80 shadow-2xl rounded-xl p-4 transition-all duration-500 transform translate-x-[120%] " + bgColor + " text-white pointer-events-auto";
        
        toast.innerHTML = 
            '<div class="flex-shrink-0 text-xl mt-0.5">' + icon + '</div>' +
            '<div class="ml-3 w-0 flex-1 relative">' +
                '<p class="font-bold text-sm leading-tight">' + title + '</p>' +
                '<p class="text-sm mt-1 text-white/90 leading-snug">' + message + '</p>' +
            '</div>' +
            '<button onclick="this.parentElement.remove()" class="ml-4 flex-shrink-0 text-white/70 hover:text-white transition-colors">' +
                '<i class="fa-solid fa-xmark"></i>' +
            '</button>';
        
        container.appendChild(toast);
        
        setTimeout(function() { toast.classList.remove('translate-x-[120%]'); }, 50);
        
        setTimeout(function() {
            if (toast.parentElement) {
                toast.classList.add('translate-x-[120%]');
                setTimeout(function() { toast.remove(); }, 500);
            }
        }, 4000);
    }
</script>

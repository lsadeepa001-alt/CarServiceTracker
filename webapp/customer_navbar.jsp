<nav class="bg-indigo-600 shadow-md fixed top-0 z-50 w-full">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
    <div class="flex items-center space-x-4">
      <button id="cust-mobile-menu-btn" class="text-white md:hidden focus:outline-none hover:text-indigo-200">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        </svg>
      </button>
      <span class="text-white font-bold text-xl tracking-wider">SwiftDrive Services</span>
    </div>

    <div id="cust-desktop-menu" class="hidden md:flex space-x-2 items-center">
      <!-- Injected by script -->
    </div>

    <div class="flex items-center pl-2">
       <a href="LogoutServlet" onclick="confirmLogout(event)" class="text-white bg-indigo-500 py-1.5 px-4 rounded hover:bg-indigo-700 shadow-inner font-bold text-sm transition-colors duration-200">Sign Out</a>
    </div>
  </div>

  <div id="cust-mobile-menu" class="hidden bg-indigo-700 px-4 py-3 shadow-inner md:hidden">
    <div class="flex flex-col space-y-2" id="cust-mobile-menu-list">
      <!-- Injected by script -->
    </div>
  </div>
</nav>

<script>
  const custTabs = [
    { name: 'Dashboard', link: 'customer_dashboard.jsp', icon: 'fa-table-columns' },
    { name: 'My Garage', link: 'customer_vehicles.jsp', icon: 'fa-warehouse' },
    { name: 'Appointments', link: 'book_appointment.jsp', icon: 'fa-calendar-check' }
  ];

  const cDesktopMenu = document.getElementById('cust-desktop-menu');
  const cMobileMenuList = document.getElementById('cust-mobile-menu-list');
  const cCurrentPage = window.location.pathname.split('/').pop();

  function createCustomerTabs() {
    cDesktopMenu.innerHTML = '';
    cMobileMenuList.innerHTML = '';

    custTabs.forEach(tab => {
      const isActive = cCurrentPage === tab.link;

      // Desktop
      const dTab = document.createElement('a');
      dTab.href = tab.link;
      dTab.className = isActive 
        ? 'text-white bg-indigo-800 px-4 py-2 rounded-lg shadow-inner transition-colors duration-300 text-sm font-semibold flex items-center gap-2' 
        : 'text-indigo-100 hover:text-white hover:bg-indigo-500 px-4 py-2 rounded-lg transition-colors duration-300 text-sm font-medium flex items-center gap-2';
      dTab.innerHTML = '<i class="fa-solid ' + tab.icon + '"></i> ' + tab.name;
      cDesktopMenu.appendChild(dTab);

      // Mobile
      const mTab = document.createElement('a');
      mTab.href = tab.link;
      mTab.className = isActive 
        ? 'text-white bg-indigo-800 px-3 py-2 rounded-md transition-colors duration-300 block font-bold text-sm' 
        : 'text-indigo-200 hover:text-white hover:bg-indigo-500 px-3 py-2 rounded-md transition-colors duration-300 block text-sm';
      mTab.innerHTML = '<i class="fa-solid ' + tab.icon + ' w-5"></i> ' + tab.name;
      cMobileMenuList.appendChild(mTab);
    });
  }

  createCustomerTabs();

  const cBtn = document.getElementById('cust-mobile-menu-btn');
  const cMobileMenu = document.getElementById('cust-mobile-menu');
  
  if (cBtn) {
    cBtn.addEventListener('click', () => {
      cMobileMenu.classList.toggle('hidden');
    });
  }
</script>

<nav class="bg-blue-600 shadow-md">
  <div class="max-w-7xl mx-auto px-4 py-2 flex items-center justify-between">
    <div class="flex items-center space-x-4">
      <button id="mobile-menu-btn" class="text-white md:hidden focus:outline-none hover:text-gray-200">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        </svg>
      </button>
      <span class="text-white text-2xl font-bold">SwiftDrive Services</span>
    </div>

    <div id="desktop-menu" class="hidden md:flex space-x-3">
      </div>

    <div class="flex items-center">
      <a href="index.jsp" class="text-white bg-red-500 py-2 px-3 rounded-full hover:bg-red-600 transition-colors duration-300">Logout</a>
    </div>
  </div>

  <div id="mobile-menu" class="hidden bg-blue-700 px-4 py-3 shadow-inner md:hidden">
    <div class="flex flex-col space-y-3" id="mobile-menu-list">
      </div>
  </div>
</nav>

<script>
  // --- UPGRADED TABS ARRAY ---
  const tabs = [
    { name: 'Dashboard', link: 'dashboard.jsp' },
    { name: 'Inventory', link: 'inventory.jsp' },
    { name: 'Appointments', link: 'manage_appointments.jsp' },
    { name: 'Billing', link: 'billing_dashboard.jsp' }, // <-- NEW BILLING DOOR ADDED HERE!
    { name: 'Manage Users', link: 'manage-users.jsp' },
    { name: 'Manage Vehicle', link: 'manage-vehicle.jsp' },
    { name: 'Feedback', link: 'admin_feedback.jsp' }
  ];

  const desktopMenu = document.getElementById('desktop-menu');
  const mobileMenuList = document.getElementById('mobile-menu-list');

  // Get current page filename
  const currentPage = window.location.pathname.split('/').pop();

  function createTabs() {
    // Clear existing tabs (if any)
    desktopMenu.innerHTML = '';
    mobileMenuList.innerHTML = '';

    tabs.forEach(tab => {
      // Check if this tab is active
      const isActive = currentPage === tab.link;
      
      // Desktop Tabs
      const dTab = document.createElement('a');
      dTab.href = tab.link;
      dTab.className = isActive 
        ? 'text-white bg-blue-900 px-3 py-2 rounded-full transition-colors duration-300 font-medium' 
        : 'text-white hover:bg-blue-500 px-3 py-2 rounded-full transition-colors duration-300';
      dTab.textContent = tab.name;
      desktopMenu.appendChild(dTab);

      // Mobile Tabs
      const mTab = document.createElement('a');
      mTab.href = tab.link;
      mTab.className = isActive 
        ? 'text-white bg-blue-900 px-3 py-2 rounded-md transition-colors duration-300 block font-medium' 
        : 'text-white hover:bg-blue-500 px-3 py-2 rounded-md transition-colors duration-300 block';
      mTab.textContent = tab.name;
      mobileMenuList.appendChild(mTab);
    });
  }

  createTabs();

  // Toggle mobile menu visibility
  const btn = document.getElementById('mobile-menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  
  if (btn) {
    btn.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // Close mobile menu when clicking on a link
  mobileMenuList.addEventListener('click', () => {
    mobileMenu.classList.add('hidden');
  });
</script>
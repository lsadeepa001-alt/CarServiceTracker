<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
function confirmLogout(event) {
    event.preventDefault();
    const targetUrl = event.currentTarget.href;
    
    Swal.fire({
      title: 'Sign Out?',
      text: "Are you sure you want to securely log out?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#4f46e5',
      cancelButtonColor: '#ef4444',
      confirmButtonText: 'Yes, log out!'
    }).then((result) => {
      if (result.isConfirmed) {
        window.location.href = targetUrl;
      }
    });
}
</script>

<?php
session_start();
require 'db.php';

// Ellenőrizd, hogy a felhasználó be van-e jelentkezve
if (!isset($_SESSION['user_email'])) {
    header("Location: login.php");
    exit;
}

// Kiírhatod a felhasználó nevét vagy e-mail címét
$pdo = db();
$stmt = $pdo->prepare("SELECT players_pyr.*, saves_sae.* 
FROM players_pyr 
LEFT JOIN saves_sae ON players_pyr.email = saves_sae.PYR_id 
WHERE players_pyr.email = :email");

$stmt->execute([
    'email' => $_SESSION['user_email']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DELVE-PCG UCP Saves</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="./img/favico2.png" type="image/png">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Roboto:wght@500;700&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="UCP/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="UCP/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/UCPbootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/UCPstyle.css" rel="stylesheet">
</head>

<body>
    <div class="container-fluid position-relative d-flex p-0">

        <!-- Sidebar Start -->
        <div class="sidebar pe-4 pb-3">
            <nav class="navbar bg-secondary navbar-dark">
                <h3><img id='delvelogo' src="./img/DELVE-PCG_logo2.png" alt="DELVE-PCG_logo" id="kep"></i>User Control Panel</h3>
                <a href="#" class="navbar-brand mx-4 mb-3"></a>
                <div class="d-flex align-items-center ms-4 mb-4">
                </div>
                <div class="navbar-nav w-100">
                    <a href="UCP.php" class="nav-item nav-link"><i class="fa fa-tachometer-alt me-2"></i>Dashboard</a>
                        <!--<div class="nav-item dropdown">
                            <a href="#" class="nav-link" data-bs-toggle="dropdown"><i class="fa fa-laptop me-2"></i>Elements</a>
                        </div> ezt még a régebbi verziók letöltésénél lehet használnám-->
                        <!--<a href="form.html" class="nav-item nav-link"><i class="fa fa-keyboard me-2"></i>Forms</a>-->
                    <a href="saves.php" class="nav-item nav-link active"><i class="fa fas fa-save me-2"></i>Saves</a>
                    <a href="versions.php" class="nav-item nav-link"><i class="fa fa-sharp-duotone fa-light fa-download me-2"></i>Other Versions</a>
                    <a href="TOS.html" class="nav-item nav-link" target="_blank"><i class="fa ffa-solid fa-newspaper me-2"></i>Terms of Service</a>
                    <a href="privacy_policy.html" class="nav-item nav-link" target="_blank"><i class="fa ffa-solid fa-newspaper me-2"></i>Privacy Policy</a>
                    <div class="nav-item dropdown">
                    </div>
                </div>
            </div>
        </nav>
    </div>
    <!-- Sidebar End -->


    <!-- Content Start -->
    <div class="content">
        <!-- Navbar Start -->
        <nav class="navbar navbar-expand bg-secondary navbar-dark sticky-top px-4 py-0">
            <a href="#" class="sidebar-toggler flex-shrink-0">
                <i class="fa fa-bars"></i>
            </a>
            <p id="sitetitle">
            <p id='belsotitle' class="mx-auto navbar-brand"><?php echo htmlspecialchars($user['username']); ?>'s Profile</p>
            </p>
            <div class="navbar-nav align-items-center ms-auto">
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                        <i class="fa fa-bell me-lg-2"></i>
                        <span class="d-none d-lg-inline-flex">Notification</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end bg-secondary border-0 rounded-0 rounded-bottom m-0">
                        <a href="#" class="dropdown-item">
                        <h6 class="fw-normal mb-0">We are working very hard to complete this page. <br> Thank you for understanding.</h6>
                        <small>Currently</small>
                        </a>
                    </div>
                </div>
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                        <span class="d-none d-lg-inline-flex"><?php echo htmlspecialchars($user['username']); ?></span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end bg-secondary border-0 rounded-0 rounded-bottom m-0">
                        <a href="#" class="dropdown-item">Settings</a>
                        <a href="logout.php" class="dropdown-item">Log Out</a>
                    </div>
                </div>
            </div>
        </nav>
        <!-- Navbar End -->


        <!--- General Save Informations -->
        <div class="container-fluid pt-4 px-4">
            <div class="row g-4">
                <div class="col-sm-12 col-xl-12">
                    <div class="bg-secondary rounded h-100 p-4">
                        <h6 class="mb-4"></h6>
                        <table class="table table-hover">
                            <thead>
                                <tr>                                    
                                    <th scope="col" class="fs-5 fw-bold">General Save Informations:</th>
                                    <th></th>
                                    <th></th>                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr>                                    
                                <th class="fw-bold">Longest playtime:</th>
                                    <td></td>
                                    <td><?php echo htmlspecialchars($user['playtime']); ?></td>
                                </tr>
                                <th class="fw-bold">Game's won:</th>
                                    <td></td>
                                    <td><?php echo htmlspecialchars($user['games_won']); ?></td>
                                </tr>
                                <th class="fw-bold">Game's lost:</th>
                                    <td></td>
                                    <td><?php echo htmlspecialchars($user['games_lost']); ?></td>
                                </tr>
                                <tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!--  General Save Informations End -->

        <!-- Footer Start -->
        <div class="container-fluid pt-4 px-4">
            <div class="bg-secondary rounded-top p-4">
                <div class="row">
                    <div class="col-12 col-sm-6 text-center text-sm-start">
                        &copy; <strong>DELVE-PCG</strong>, All Right Reserved.
                    </div>
                    <div class="col-12 col-sm-6 text-center text-sm-end">
                        Designed By Szabó Levente</a>
                        <br>Distributed By: <a href="https://themewagon.com" target="_blank">ThemeWagon</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer End -->
    </div>
    <!-- Content End -->

    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="UCP/lib/chart/chart.min.js"></script>
    <script src="UCP/lib/easing/easing.min.js"></script>
    <script src="UCP/lib/waypoints/waypoints.min.js"></script>
    <script src="UCP/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="UCP/lib/tempusdominus/js/moment.min.js"></script>
    <script src="UCP/lib/tempusdominus/js/moment-timezone.min.js"></script>
    <script src="UCP/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

    <!-- Template Javascript -->
    <script src="js/UCPmain.js"></script>
</body>
</html>
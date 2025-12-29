import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRole?: 'client' | 'transporter';
}

export default function ProtectedRoute({ children, allowedRole }: ProtectedRouteProps) {
  const { user, isAuthenticated } = useAuth();

  // Si non authentifié, rediriger vers la page de connexion
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  // Si un rôle spécifique est requis et que l'utilisateur n'a pas ce rôle
  if (allowedRole && user?.type !== allowedRole) {
    // Rediriger vers le bon dashboard selon le rôle réel
    if (user?.type === 'client') {
      return <Navigate to="/home" replace />;
    } else if (user?.type === 'transporter') {
      return <Navigate to="/transporter-dashboard" replace />;
    }
  }

  return <>{children}</>;
}

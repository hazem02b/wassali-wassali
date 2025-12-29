import { createContext, useContext, useState, ReactNode, useEffect } from 'react';
import apiService from '../services/api.service';
import { websocketService } from '../services/websocket.service';
import { NotificationService } from './NotificationService';
import { User } from '../types';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string, type: 'client' | 'transporter') => Promise<void>;
  signup: (userData: Partial<User>) => Promise<void>;
  logout: () => void;
  updateUser: (userData: Partial<User>) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);

  // Charger l'utilisateur au démarrage
  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    const savedUser = localStorage.getItem('user');
    
    if (savedToken && savedUser) {
      setToken(savedToken);
      setUser(JSON.parse(savedUser));
    }
  }, []);

  // Connecter/déconnecter WebSocket selon l'authentification
  useEffect(() => {
    if (token) {
      // Connecter au WebSocket pour les notifications en temps réel
      websocketService.connect(token);
      
      // S'abonner aux notifications
      const unsubscribe = websocketService.subscribe((notification) => {
        console.log('📨 Notification WebSocket:', notification);
        
        // Afficher selon le type
        switch (notification.type) {
          case 'new_message':
            NotificationService.info(
              notification.title,
              notification.message
            );
            break;
          case 'booking_update':
            NotificationService.success(
              notification.title,
              notification.message
            );
            break;
          case 'incoming_call':
            NotificationService.warning(
              notification.title,
              notification.message
            );
            break;
          default:
            NotificationService.info(
              notification.title,
              notification.message
            );
        }
      });
      
      return () => {
        unsubscribe();
        websocketService.disconnect();
      };
    }
  }, [token]);

  const login = async (email: string, password: string, type: 'client' | 'transporter') => {
    try {
      const result = await apiService.login(email, password, type) as any;
      
      const userData: User = {
        id: result.user.id.toString(),
        name: result.user.name,
        email: result.user.email,
        phone: result.user.phone || '',
        type: result.user.role as 'client' | 'transporter',
        verified: result.user.is_verified,
        address: result.user.address,
      };
      
      // Vérification : le rôle de l'utilisateur doit correspondre au type demandé
      if (userData.type !== type) {
        throw new Error(`Ce compte est enregistré en tant que ${userData.type}. Veuillez utiliser le bon type de connexion.`);
      }
      
      localStorage.setItem('token', result.access_token);
      localStorage.setItem('user', JSON.stringify(userData));
      
      setToken(result.access_token);
      setUser(userData);
    } catch (error: any) {
      console.error('Erreur de connexion:', error);
      throw new Error(error?.message || 'Erreur de connexion');
    }
  };

  const signup = async (userData: Partial<User> & { password?: string }) => {
    try {
      if (!userData.email || !userData.password || !userData.name || !userData.type) {
        throw new Error('Informations manquantes');
      }

      const result = await apiService.register({
        email: userData.email,
        password: userData.password,
        name: userData.name,
        phone: userData.phone || '',
        role: userData.type,
      }) as any;
      
      const newUser: User = {
        id: result.user.id.toString(),
        name: result.user.name,
        email: result.user.email,
        phone: result.user.phone || '',
        type: result.user.role as 'client' | 'transporter',
        verified: result.user.is_verified,
        address: result.user.address,
      };
      
      localStorage.setItem('token', result.access_token);
      localStorage.setItem('user', JSON.stringify(newUser));
      
      setToken(result.access_token);
      setUser(newUser);
    } catch (error: any) {
      console.error('Erreur d\'inscription:', error);
      throw new Error(error?.message || 'Erreur lors de l\'inscription');
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setToken(null);
    setUser(null);
  };

  const updateUser = (userData: Partial<User>) => {
    if (user) {
      const updatedUser = { ...user, ...userData };
      setUser(updatedUser);
      localStorage.setItem('user', JSON.stringify(updatedUser));
    }
  };

  return (
    <AuthContext.Provider value={{
      user,
      isAuthenticated: !!user,
      login,
      signup,
      logout,
      updateUser,
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}

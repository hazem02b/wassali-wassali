import { useState, useEffect } from 'react';
import { apiService } from '../services/api.service';

export interface Conversation {
  id: string;
  name: string;
  avatar: string;
  lastMessage: string;
  timestamp: string;
  unread: number;
  online: boolean;
  userId: number;
}

export function useConversations() {
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchConversations();
  }, []);

  const fetchConversations = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const token = localStorage.getItem('token');
      if (!token) {
        setConversations([]);
        setLoading(false);
        return;
      }

      const data = await apiService.getConversations(token);
      
      // Transformer les données du backend au format attendu par le frontend
      const formattedConversations: Conversation[] = data.map((conv: any) => ({
        id: conv.conversation_id,
        name: conv.other_user_name,
        avatar: '', // Pas d'avatar pour l'instant
        lastMessage: conv.last_message,
        timestamp: conv.last_message_time,
        unread: conv.unread_count,
        online: conv.is_online,
        userId: conv.other_user_id
      }));
      
      setConversations(formattedConversations);
      
    } catch (err) {
      console.error('Error fetching conversations:', err);
      setError('Failed to load conversations');
      setConversations([]);
    } finally {
      setLoading(false);
    }
  };

  const markAsRead = async (conversationId: string) => {
    try {
      // await apiService.post(`/messages/conversations/${conversationId}/read`);
      setConversations(prev =>
        prev.map(conv =>
          conv.id === conversationId ? { ...conv, unread: 0 } : conv
        )
      );
    } catch (err) {
      console.error('Error marking as read:', err);
    }
  };

  return {
    conversations,
    loading,
    error,
    refetch: fetchConversations,
    markAsRead,
  };
}

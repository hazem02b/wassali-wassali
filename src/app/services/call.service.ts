/**
 * Service d'appels audio/vidéo avec WebRTC
 */

export type CallType = 'voice' | 'video';

export interface CallConfig {
  type: CallType;
  callerName: string;
  callerId: number;
}

class CallService {
  private peerConnection: RTCPeerConnection | null = null;
  private localStream: MediaStream | null = null;
  private remoteStream: MediaStream | null = null;

  /**
   * Initialiser un appel sortant
   */
  async initiateCall(config: CallConfig): Promise<void> {
    try {
      // Demander permissions audio/vidéo
      const constraints: MediaStreamConstraints = {
        audio: true,
        video: config.type === 'video'
      };

      this.localStream = await navigator.mediaDevices.getUserMedia(constraints);
      
      // Créer la connexion peer-to-peer
      this.peerConnection = new RTCPeerConnection({
        iceServers: [
          { urls: 'stun:stun.l.google.com:19302' },
          { urls: 'stun:stun1.l.google.com:19302' }
        ]
      });

      // Ajouter les pistes locales
      this.localStream.getTracks().forEach(track => {
        this.peerConnection!.addTrack(track, this.localStream!);
      });

      // Gérer les pistes distantes
      this.peerConnection.ontrack = (event) => {
        this.remoteStream = event.streams[0];
      };

      console.log('📞 Appel initié');
    } catch (error) {
      console.error('Erreur initialisation appel:', error);
      throw error;
    }
  }

  /**
   * Accepter un appel entrant
   */
  async acceptCall(config: CallConfig): Promise<void> {
    await this.initiateCall(config);
    console.log('✅ Appel accepté');
  }

  /**
   * Rejeter/terminer un appel
   */
  endCall(): void {
    // Arrêter toutes les pistes
    if (this.localStream) {
      this.localStream.getTracks().forEach(track => track.stop());
      this.localStream = null;
    }

    // Fermer la connexion
    if (this.peerConnection) {
      this.peerConnection.close();
      this.peerConnection = null;
    }

    this.remoteStream = null;
    console.log('📴 Appel terminé');
  }

  /**
   * Obtenir le stream local (pour affichage vidéo)
   */
  getLocalStream(): MediaStream | null {
    return this.localStream;
  }

  /**
   * Obtenir le stream distant (pour affichage vidéo)
   */
  getRemoteStream(): MediaStream | null {
    return this.remoteStream;
  }

  /**
   * Activer/désactiver le micro
   */
  toggleMicrophone(): boolean {
    if (this.localStream) {
      const audioTrack = this.localStream.getAudioTracks()[0];
      if (audioTrack) {
        audioTrack.enabled = !audioTrack.enabled;
        return audioTrack.enabled;
      }
    }
    return false;
  }

  /**
   * Activer/désactiver la caméra
   */
  toggleCamera(): boolean {
    if (this.localStream) {
      const videoTrack = this.localStream.getVideoTracks()[0];
      if (videoTrack) {
        videoTrack.enabled = !videoTrack.enabled;
        return videoTrack.enabled;
      }
    }
    return false;
  }
}

// Export singleton
export const callService = new CallService();

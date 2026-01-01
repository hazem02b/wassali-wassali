"""
Script pour ajouter le modèle Parcel
"""

# Lire le fichier models.py
with open('app/models/models.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Vérifier si Parcel existe déjà
if 'class Parcel' in content:
    print("Le modèle Parcel existe déjà!")
    exit(0)

# Code du modèle Parcel
parcel_model = '''

class Parcel(Base):
    """Parcel/Envoi model"""
    __tablename__ = "parcels"

    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Addresses
    pickup_address = Column(String(500), nullable=False)
    delivery_address = Column(String(500), nullable=False)
    
    # Parcel info
    description = Column(Text)
    weight = Column(Float, nullable=False)  # kg
    size = Column(String(50))  # small, medium, large
    price = Column(Float, nullable=False)
    
    # Status
    status = Column(String(50), default="pending")  # pending, assigned, in_transit, delivered
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    sender = relationship("User", foreign_keys=[sender_id])
'''

# Ajouter à la fin du fichier
with open('app/models/models.py', 'a', encoding='utf-8') as f:
    f.write(parcel_model)

print("Modèle Parcel ajouté avec succès!")

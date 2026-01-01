"""
Parcels (Envois) Endpoints
"""
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime

from app.db.database import get_db
from app.models.models import User, Parcel
from app.api.v1.endpoints.auth import get_current_user
from app.schemas.schemas import ParcelCreate, ParcelResponse, ParcelUpdate

router = APIRouter(prefix="/parcels", tags=["parcels"])


@router.post("/", response_model=ParcelResponse, status_code=status.HTTP_201_CREATED)
def create_parcel(
    parcel_data: ParcelCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Create a new parcel/envoi.
    Only authenticated users can create parcels.
    """
    # Create new parcel
    new_parcel = Parcel(
        sender_id=current_user.id,
        pickup_address=parcel_data.pickup_address,
        delivery_address=parcel_data.delivery_address,
        description=parcel_data.description,
        weight=parcel_data.weight,
        size=parcel_data.size,
        price=parcel_data.price,
        status="pending",
        created_at=datetime.utcnow()
    )
    
    db.add(new_parcel)
    db.commit()
    db.refresh(new_parcel)
    
    return new_parcel


@router.get("/", response_model=List[ParcelResponse])
def get_my_parcels(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get all parcels created by the current user.
    """
    parcels = db.query(Parcel).filter(Parcel.sender_id == current_user.id).all()
    return parcels


@router.get("/{parcel_id}", response_model=ParcelResponse)
def get_parcel(
    parcel_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get details of a specific parcel.
    """
    parcel = db.query(Parcel).filter(Parcel.id == parcel_id).first()
    
    if not parcel:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Parcel not found"
        )
    
    # Check if user has access to this parcel
    if parcel.sender_id != current_user.id and current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to access this parcel"
        )
    
    return parcel


@router.put("/{parcel_id}", response_model=ParcelResponse)
def update_parcel(
    parcel_id: int,
    parcel_update: ParcelUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update a parcel.
    Only the sender can update their parcel.
    """
    parcel = db.query(Parcel).filter(Parcel.id == parcel_id).first()
    
    if not parcel:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Parcel not found"
        )
    
    # Check authorization
    if parcel.sender_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this parcel"
        )
    
    # Update fields
    if parcel_update.pickup_address is not None:
        parcel.pickup_address = parcel_update.pickup_address
    if parcel_update.delivery_address is not None:
        parcel.delivery_address = parcel_update.delivery_address
    if parcel_update.description is not None:
        parcel.description = parcel_update.description
    if parcel_update.weight is not None:
        parcel.weight = parcel_update.weight
    if parcel_update.size is not None:
        parcel.size = parcel_update.size
    if parcel_update.price is not None:
        parcel.price = parcel_update.price
    if parcel_update.status is not None:
        parcel.status = parcel_update.status
    
    db.commit()
    db.refresh(parcel)
    
    return parcel


@router.delete("/{parcel_id}")
def delete_parcel(
    parcel_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Delete a parcel.
    Only the sender can delete their parcel.
    """
    parcel = db.query(Parcel).filter(Parcel.id == parcel_id).first()
    
    if not parcel:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Parcel not found"
        )
    
    # Check authorization
    if parcel.sender_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this parcel"
        )
    
    db.delete(parcel)
    db.commit()
    
    return {"message": "Parcel deleted successfully"}


@router.post("/location/track")
def track_parcel_location(
    parcel_id: int,
    db: Session = Depends(get_db)
):
    """
    Track parcel location.
    Public endpoint for tracking.
    """
    parcel = db.query(Parcel).filter(Parcel.id == parcel_id).first()
    
    if not parcel:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Parcel not found"
        )
    
    return {
        "parcel_id": parcel.id,
        "status": parcel.status,
        "pickup_address": parcel.pickup_address,
        "delivery_address": parcel.delivery_address,
        "current_location": getattr(parcel, 'current_location', parcel.pickup_address)
    }

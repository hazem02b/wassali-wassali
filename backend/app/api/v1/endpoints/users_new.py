from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.db.database import get_db
from app.models.models import User, Booking, Trip
from app.api.v1.endpoints.auth import get_current_user
from app.schemas.schemas import UserResponse, UserUpdate
from datetime import datetime

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/transporters/all", response_model=List[UserResponse])
def get_all_transporters(
    db: Session = Depends(get_db)
):
    """
    Get list of all transporters.
    Public endpoint - no authentication required.
    """
    transporters = db.query(User).filter(User.role == "transporter").all()
    return transporters


@router.get("/transporters/available", response_model=List[UserResponse])
def get_available_transporters(
    db: Session = Depends(get_db)
):
    """
    Get list of available transporters.
    Public endpoint - no authentication required.
    """
    transporters = db.query(User).filter(
        User.role == "transporter"
    ).all()
    return transporters

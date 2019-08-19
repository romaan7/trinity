from django.db import models
from django.utils import timezone


class CityEvents(models.Model):
    nametext = models.CharField(max_length=500)
    descriptiontext = models.CharField(max_length=1500)
    organization_id = models.BigIntegerField()
    online_event = models.CharField(max_length=500)
    startutc = models.DateTimeField('startutc')
    endutc = models.DateTimeField('endutc')
    # capacity = models.IntegerField()
    listed = models.BooleanField()
    is_free = models.BooleanField()
    url = models.CharField(max_length=500)
    resource_uri = models.CharField(max_length=500)
    cm_last_insert_dttm = models.DateTimeField(default=timezone.now, blank=True)

    def __str__(self):
        return self.nametext




# Create your models here.
# nametext                        
# namehtml                        
# descriptiontext                 
# descriptionhtml                 
# id                              
# url                             
# starttimezone                   
# startlocal                      
# startutc                        
# endtimezone                     
# endlocal                        
# endutc                          
# organization_id                 
# created                         
# changed                         
# capacity                        
# capacity_is_custom              
# status                          
# currency                        
# listed                          
# shareable                       
# online_event                    
# tx_time_limit                   
# hide_start_date                 
# hide_end_date                   
# locale                          
# is_locked                       
# privacy_setting                 
# is_series                       
# is_series_parent                
# inventory_type                  
# is_reserved_seating             
# show_pick_a_seat                
# show_seatmap_thumbnail          
# show_colors_in_seatmap_thumbnail
# source                          
# is_free                         
# version                         
# logo_id                         
# organizer_id                    
# venue_id                        
# category_id                     
# subcategory_id                  
# format_id                       
# resource_uri                    
# is_externally_ticketed          
# logocrop_masktop_leftx          
# logocrop_masktop_lefty          
# logocrop_maskwidth              
# logocrop_maskheight             
# logooriginalurl                 
# logooriginalwidth               
# logooriginalheight              
# logoid                          
# logourl                         
# logoaspect_ratio                
# logoedge_color                  
# logoedge_color_set              

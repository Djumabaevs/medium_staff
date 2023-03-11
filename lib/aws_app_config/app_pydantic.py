from aws_lambda_powertools.utilities.parameters import (AppConfigProvider, GetParameterError, TransformParameterError)
from pydantic import BaseModel, ValidationError
from typing import Optional


# Pydantic class which represents the parsed enviorment variables
class EnvVars(BaseModel):
  env_var_1: str
  env_var_2: str
  # requires variables for app config below, application -> enviorment -> configuration name
  APP_CONF_APPLICATION: str  # required for feature toggles, what application to load
  APP_CONF_ENVIORMENT: str   # required for feature toggles, what enviorment to load
  APP_CONF_CONFNAME: str     # required for feature toggles, what configuration to load

  
 
# env vars singelton
CONF: EnvVars = None

# feature toggles pydantic model, represents the feature toggles we expect to load from AWS AppConfig and use in the lambda
class AppConfToggles(BaseModel):
# a default value + Optional type is crucial and considered as best practice, see bottom of blog for explanation
    feature1: Optional[bool] = False 
    feature2: Optional[bool] = False
    log_level: str           = "INFO"


# app config singeltons
APPCONF_PROVIDER: AppConfigProvider = None # a class which is used to access aws appconfig, has internal cache for stored RAW configurations
FEATURE_TOGGLES: AppConfToggles = None # current instance of the toggles, containes the latest parsed & validated feature toggles values


def check_env_vars() -> None:
    global CONF
    if CONF is None:
        CONF = EnvVars(**os.environ) # load enviroment variables Dict into EnvVars Pydantic constructor
    
def load_feature_toggles() -> None:
    global APPCONF_PROVIDER, FEATURE_TOGGLES, CONF
    if APPCONF_PROVIDER is None:
        # configure appconf provider, point it to the application->enviroment to use
        APPCONF_PROVIDER = AppConfigProvider(environment=env_vars.APP_CONF_ENVIORMENT, application=env_vars.APP_CONF_APPLICATION)
        
    # get a specific configuration from the previously selected application->enviorments
    conf_json = APPCONF_PROVIDER.get(name=env_vars.APP_CONF_CONFNAME, transform="json", max_age=600) # parse result conf as JSON, keep in cache for 600 seconds
        
    # conf_json is a python Dict which serves as input for Pydantic class constructor of AppConfToggles  
    FEATURE_TOGGLES = AppConfToggles(**conf_json) # load JSON into pydantic, parse the toggles, instantiate the singletone
 

def lambda_handler(event, context):
    check_env_vars()
    load_feature_toggles()
    global FEATURE_TOGGLES
    
    if FEATURE_TOGGLES.feature1:
      # handle feature is turned on
    else:
      # handled feature is turned off
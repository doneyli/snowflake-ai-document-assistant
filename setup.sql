USE ROLE ACCOUNTADMIN;

-- Fetch most recent files from Github repository
ALTER GIT REPOSITORY GITHUB_REPO_DOCUMENT_ASSISTANT FETCH;

-- Create Streamlit app with method based on status of Behavior Change Bundle 2025_01
BEGIN
      -- Create stage for the Streamlit App
      CREATE OR REPLACE STAGE STREAMLIT_APP
        DIRECTORY = (ENABLE = TRUE)
        ENCRYPTION = ( TYPE = 'SNOWFLAKE_FULL' );

      -- Copy Streamlit App into to stage
      COPY FILES
        INTO @STREAMLIT_APP
        FROM @CORTEX_AI_DB.DOCUMENT_ASSISTANT.GITHUB_REPO_DOCUMENT_ASSISTANT/branches/main/app/;
      ALTER STAGE STREAMLIT_APP REFRESH;

      -- Create Streamlit App
      CREATE OR REPLACE STREAMLIT CORTEX_AI_CONTRACT_CHAT_APP
          ROOT_LOCATION = '@CORTEX_AI_DB.DOCUMENT_ASSISTANT.STREAMLIT_APP'
          MAIN_FILE = '/streamlit_app.py'
          QUERY_WAREHOUSE = COMPUTE_WH
          TITLE = 'Cortex AI Contracts Chat App'
          COMMENT = 'Demo Streamlit frontend for Document Assistant';
END;

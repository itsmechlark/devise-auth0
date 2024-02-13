sudo chown -R vscode:vscode ${BUNDLE_PATH} && \
    bundle install --jobs=3 --retry=3 && \
    bundle exec appraisal install

# Rebuild PostgreSQL
dropdb --if-exists devise_auth0_test
dropdb --if-exists devise_auth0_development
createdb -E UTF8 -T template0 devise_auth0_test --lc-collate en_US.UTF-8
createdb -E UTF8 -T template0 devise_auth0_development --lc-collate en_US.UTF-8

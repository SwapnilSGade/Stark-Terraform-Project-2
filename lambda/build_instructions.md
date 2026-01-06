Build steps:

1. Create virtual env and install dependencies:
   python -m venv .venv
   . .venv/Scripts/activate  (Windows) or source .venv/bin/activate (Linux/macOS)
   pip install -r requirements.txt
   pip freeze > requirements.lock

2. Package for Lambda (no compiled deps required):
   zip -r package.zip handler.py

   Note: For large dependencies, you could vendor site-packages:
   cd .venv/lib/python3.12/site-packages
   zip -r ../../../../lambda/package.zip .

   Then add handler.py:
   cd ../../../../lambda
   zip -g package.zip handler.py

3. Ensure package.zip sits at lambda/package.zip relative to terraform/aws/lambda.tf.

4. Optional: Use a Lambda layer if site-packages exceed direct zip size.
# This script was copied from https://github.com/ByeongsuPark/byeongsupark.github.io
# Date copied: 2024-06-30
# Original Author: Byeongsu Park
#
# Modifications made by: Young Choi
# Date modified: 2024-06-30
# Description of modifications: Updated branch names.

git checkout main
rm -rf _site/
JEKYLL_ENV=production bundle exec jekyll build 
git add --all
git commit -m "`date`"
git push origin main
git subtree push --prefix=_site/ origin gh-pages
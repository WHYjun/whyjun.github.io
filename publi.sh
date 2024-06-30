git checkout main
rm -rf _site/
JEKYLL_ENV=production bundle exec jekyll build 
git add --all
git commit -m "`date`"
git push origin main
git subtree push --prefix=_site/ origin gh-pages
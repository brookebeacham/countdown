export PATH=/root/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
eval "$(rbenv init -)"
git checkout master
git pull origin master
ruby countdown.rb
python strandtest.py -c --timeout 25200 # 7 hours
ruby wipe.rb

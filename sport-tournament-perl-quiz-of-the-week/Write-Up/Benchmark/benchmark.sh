(for MODULE in *_*.pm ; do
    PERSON=${MODULE%.pm}
    echo "== $PERSON"
    time perl -M$PERSON bench.pl
done) > dump.txt 2>&1


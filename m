Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C972024830E
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 12:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHRKby (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 06:31:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:59882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRKby (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 06:31:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C804FAF8E;
        Tue, 18 Aug 2020 10:32:17 +0000 (UTC)
Subject: Re: [PATCH 4/4] bcache: use part_[begin|end]_io_acct instead of
 disk_[begin|end]_io_acct
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, axboe@kernel.dk, kernel-team@fb.com,
        song@kernel.org
References: <20200818070238.1323126-1-songliubraving@fb.com>
 <20200818070238.1323126-5-songliubraving@fb.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 mQINBFYX6S8BEAC9VSamb2aiMTQREFXK4K/W7nGnAinca7MRuFUD4JqWMJ9FakNRd/E0v30F
 qvZ2YWpidPjaIxHwu3u9tmLKqS+2vnP0k7PRHXBYbtZEMpy3kCzseNfdrNqwJ54A430BHf2S
 GMVRVENiScsnh4SnaYjFVvB8SrlhTsgVEXEBBma5Ktgq9YSoy5miatWmZvHLFTQgFMabCz/P
 j5/xzykrF6yHo0rHZtwzQzF8rriOplAFCECp/t05+OeHHxjSqSI0P/G79Ll+AJYLRRm9til/
 K6yz/1hX5xMToIkYrshDJDrUc8DjEpISQQPhG19PzaUf3vFpmnSVYprcWfJWsa2wZyyjRFkf
 J51S82WfclafNC6N7eRXedpRpG6udUAYOA1YdtlyQRZa84EJvMzW96iSL1Gf+ZGtRuM3k49H
 1wiWOjlANiJYSIWyzJjxAd/7Xtiy/s3PRKL9u9y25ftMLFa1IljiDG+mdY7LyAGfvdtIkanr
 iBpX4gWXd7lNQFLDJMfShfu+CTMCdRzCAQ9hIHPmBeZDJxKq721CyBiGAhRxDN+TYiaG/UWT
 7IB7LL4zJrIe/xQ8HhRO+2NvT89o0LxEFKBGg39yjTMIrjbl2ZxY488+56UV4FclubrG+t16
 r2KrandM7P5RjR+cuHhkKseim50Qsw0B+Eu33Hjry7YCihmGswARAQABtBhDb2x5IExpIDxj
 b2x5bGlAc3VzZS5kZT6JAlYEEwEIAEACGyMHCwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgBYh
 BOo+RS/0+Uhgjej60Mc5B5Nrffj8BQJcR84dBQkY++fuAAoJEMc5B5Nrffj8ixcP/3KAKg1X
 EcoW4u/0z+Ton5rCyb/NpAww8MuRjNW82UBUac7yCi1y3OW7NtLjuBLw5SaVG5AArb7IF3U0
 qTOobqfl5XHsT0o5wFHZaKUrnHb6y7V3SplsJWfkP3JmOooJsQB3z3K96ZTkFelsNb0ZaBRu
 gV+LA4MomhQ+D3BCDR1it1OX/tpvm2uaDF6s/8uFtcDEM9eQeqATN/QAJ49nvU/I8zDSY9rc
 0x9mP0x+gH4RccbnoPu/rUG6Fm1ZpLrbb6NpaYBBJ/V1BC4lIOjnd24bsoQrQmnJn9dSr60X
 1MY60XDszIyzRw7vbJcUn6ZzPNFDxFFT9diIb+wBp+DD8ZlD/hnVpl4f921ZbvfOSsXAJrKB
 1hGY17FPwelp1sPcK2mDT+pfHEMV+OQdZzD2OCKtza/5IYismJJm3oVUYMogb5vDNAw9X2aP
 XgwUuG+FDEFPamFMUwIfzYHcePfqf0mMsaeSgtA/xTxzx/0MLjUJHl46Bc0uKDhv7QUyGz0j
 Ywgr2mHTvG+NWQ/mDeHNGkcnsnp3IY7koDHnN2xMFXzY4bn9m8ctqKo2roqjCzoxD/njoAhf
 KBzdybLHATqJG/yiZSbCxDA1n/J4FzPyZ0rNHUAJ/QndmmVspE9syFpFCKigvvyrzm016+k+
 FJ59Q6RG4MSy/+J565Xj+DNY3/dCuQINBFYX6S8BEADZP+2cl4DRFaSaBms08W8/smc5T2CO
 YhAoygZn71rB7Djml2ZdvrLRjR8Qbn0Q/2L2gGUVc63pJnbrjlXSx2LfAFE0SlfYIJ11aFdF
 9w7RvqWByQjDJor3Z0fWvPExplNgMvxpD0U0QrVT5dIGTx9hadejCl/ug09Lr6MPQn+a4+qs
 aRWwgCSHaIuDkH3zI1MJXiqXXFKUzJ/Fyx6R72rqiMPHH2nfwmMu6wOXAXb7+sXjZz5Po9GJ
 g2OcEc+rpUtKUJGyeQsnCDxUcqJXZDBi/GnhPCcraQuqiQ7EGWuJfjk51vaI/rW4bZkA9yEP
 B9rBYngbz7cQymUsfxuTT8OSlhxjP3l4ZIZFKIhDaQeZMj8pumBfEVUyiF6KVSfgfNQ/5PpM
 R4/pmGbRqrAAElhrRPbKQnCkGWDr8zG+AjN1KF6rHaFgAIO7TtZ+F28jq4reLkur0N5tQFww
 wFwxzROdeLHuZjL7eEtcnNnzSkXHczLkV4kQ3+vr/7Gm65mQfnVpg6JpwpVrbDYQeOFlxZ8+
 GERY5Dag4KgKa/4cSZX2x/5+KkQx9wHwackw5gDCvAdZ+Q81nm6tRxEYBBiVDQZYqO73stgT
 ZyrkxykUbQIy8PI+g7XMDCMnPiDncQqgf96KR3cvw4wN8QrgA6xRo8xOc2C3X7jTMQUytCz9
 0MyV1QARAQABiQI8BBgBCAAmAhsMFiEE6j5FL/T5SGCN6PrQxzkHk2t9+PwFAlxHziAFCRj7
 5/EACgkQxzkHk2t9+PxgfA//cH5R1DvpJPwraTAl24SUcG9EWe+NXyqveApe05nk15zEuxxd
 e4zFEjo+xYZilSveLqYHrm/amvQhsQ6JLU+8N60DZHVcXbw1Eb8CEjM5oXdbcJpXh1/1BEwl
 4phsQMkxOTns51bGDhTQkv4lsZKvNByB9NiiMkT43EOx14rjkhHw3rnqoI7ogu8OO7XWfKcL
 CbchjJ8t3c2XK1MUe056yPpNAT2XPNF2EEBPG2Y2F4vLgEbPv1EtpGUS1+JvmK3APxjXUl5z
 6xrxCQDWM5AAtGfM/IswVjbZYSJYyH4BQKrShzMb0rWUjkpXvvjsjt8rEXpZEYJgX9jvCoxt
 oqjCKiVLpwje9WkEe9O9VxljmPvxAhVqJjX62S+TGp93iD+mvpCoHo3+CcvyRcilz+Ko8lfO
 hS9tYT0HDUiDLvpUyH1AR2xW9RGDevGfwGTpF0K6cLouqyZNdhlmNciX48tFUGjakRFsxRmX
 K0Jx4CEZubakJe+894sX6pvNFiI7qUUdB882i5GR3v9ijVPhaMr8oGuJ3kvwBIA8lvRBGVGn
 9xvzkQ8Prpbqh30I4NMp8MjFdkwCN6znBKPHdjNTwE5PRZH0S9J0o67IEIvHfH0eAWAsgpTz
 +jwc7VKH7vkvgscUhq/v1/PEWCAqh9UHy7R/jiUxwzw/288OpgO+i+2l11Y=
Message-ID: <218caa26-3569-dbe4-de89-8849bd6eeb8f@suse.de>
Date:   Tue, 18 Aug 2020 18:31:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818070238.1323126-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/8/18 15:02, Song Liu wrote:
> This enables proper statistics in /proc/diskstats for bcache partitions.
> 
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Song Liu <songliubraving@fb.com>

The code looks good to me. It is fine to submit this bcache patch in
your submission path.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/request.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 7de82c67597ce..1d946f601f7eb 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -475,6 +475,7 @@ struct search {
>  	unsigned int		read_dirty_data:1;
>  	unsigned int		cache_missed:1;
>  
> +	struct hd_struct	*part;
>  	unsigned long		start_time;
>  
>  	struct btree_op		op;
> @@ -669,7 +670,8 @@ static void bio_complete(struct search *s)
>  {
>  	if (s->orig_bio) {
>  		/* Count on bcache device */
> -		disk_end_io_acct(s->d->disk, bio_op(s->orig_bio), s->start_time);
> +		part_end_io_acct(s->part, bio_op(s->orig_bio), s->start_time);
> +		hd_struct_put(s->part);
>  
>  		trace_bcache_request_end(s->d, s->orig_bio);
>  		s->orig_bio->bi_status = s->iop.status;
> @@ -731,7 +733,8 @@ static inline struct search *search_alloc(struct bio *bio,
>  	s->write		= op_is_write(bio_op(bio));
>  	s->read_dirty_data	= 0;
>  	/* Count on the bcache device */
> -	s->start_time		= disk_start_io_acct(d->disk, bio_sectors(bio), bio_op(bio));
> +	s->part			= disk_map_sector_rcu(d->disk, bio->bi_iter.bi_sector);
> +	s->start_time		= part_start_io_acct(s->part, bio_sectors(bio), bio_op(bio));
>  	s->iop.c		= d->c;
>  	s->iop.bio		= NULL;
>  	s->iop.inode		= d->id;
> @@ -1072,6 +1075,7 @@ struct detached_dev_io_private {
>  	unsigned long		start_time;
>  	bio_end_io_t		*bi_end_io;
>  	void			*bi_private;
> +	struct hd_struct	*part;
>  };
>  
>  static void detached_dev_end_io(struct bio *bio)
> @@ -1083,7 +1087,8 @@ static void detached_dev_end_io(struct bio *bio)
>  	bio->bi_private = ddip->bi_private;
>  
>  	/* Count on the bcache device */
> -	disk_end_io_acct(ddip->d->disk, bio_op(bio), ddip->start_time);
> +	part_end_io_acct(ddip->part, bio_op(bio), ddip->start_time);
> +	hd_struct_put(ddip->part);
>  
>  	if (bio->bi_status) {
>  		struct cached_dev *dc = container_of(ddip->d,
> @@ -1109,7 +1114,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
>  	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
>  	ddip->d = d;
>  	/* Count on the bcache device */
> -	ddip->start_time = disk_start_io_acct(d->disk, bio_sectors(bio), bio_op(bio));
> +	ddip->part = disk_map_sector_rcu(d->disk, bio->bi_iter.bi_sector);
> +	ddip->start_time = part_start_io_acct(ddip->part, bio_sectors(bio), bio_op(bio));
>  	ddip->bi_end_io = bio->bi_end_io;
>  	ddip->bi_private = bio->bi_private;
>  	bio->bi_end_io = detached_dev_end_io;
> 


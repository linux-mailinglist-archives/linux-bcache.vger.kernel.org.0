Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1202211CF
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGOQAQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 12:00:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:54534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgGOQAN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 12:00:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DE548AE54;
        Wed, 15 Jul 2020 16:00:12 +0000 (UTC)
Subject: Re: [PATCH v3 08/16] bcache: introduce meta_bucket_pages() related
 helper routines
To:     Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-9-colyli@suse.de>
 <b6083e37-9eb2-5e9e-7b90-27b1308828d2@suse.de>
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
Message-ID: <0d51646b-4feb-56ad-f1b0-4afedaa83880@suse.de>
Date:   Thu, 16 Jul 2020 00:00:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b6083e37-9eb2-5e9e-7b90-27b1308828d2@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/15 23:36, Hannes Reinecke wrote:
> On 7/15/20 4:30 PM, colyli@suse.de wrote:
>> From: Coly Li <colyli@suse.de>
>>
>> Currently the in-memory meta data like c->uuids or c->disk_buckets
>> are allocated by alloc_bucket_pages(). The macro alloc_bucket_pages()
>> calls __get_free_pages() to allocated continuous pages with order
>> indicated by ilog2(bucket_pages(c)),
>>   #define alloc_bucket_pages(gfp, c)                      \
>>       ((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
>>
>> The maximum order is defined as MAX_ORDER, the default value is 11 (and
>> can be overwritten by CONFIG_FORCE_MAX_ZONEORDER). In bcache code the
>> maximum bucket size width is 16bits, this is restricted both by KEY_SIZE
>> size and bucket_size size from struct cache_sb_disk. The maximum 16bits
>> width and power-of-2 value is (1<<15) in unit of sector (512byte). It
>> means the maximum value of bucket size in bytes is (1<<24) bytes a.k.a
>> 4096 pages.
>>
>> When the bucket size is set to maximum permitted value, ilog2(4096) is
>> 12, which exceeds the default maximum order __get_free_pages() can
>> accepted, the failed pages allocation will fail cache set registration
>> procedure and print a kernel oops message for the exceeded pages order.
>>
>> This patch introduces meta_bucket_pages(), meta_bucket_bytes(), and
>> alloc_bucket_pages() helper routines. meta_bucket_pages() indicates the
>> maximum pages can be allocated to meta data bucket, meta_bucket_bytes()
>> indicates the according maximum bytes, and alloc_bucket_pages() does
>> the pages allocation for meta bucket. Because meta_bucket_pages()
>> chooses the smaller value among the bucket size and MAX_ORDER_NR_PAGES,
>> it still works when MAX_ORDER overwritten by CONFIG_FORCE_MAX_ZONEORDER.
>>
>> Following patches will use these helper routines to decide maximum pages
>> can be allocated for different meta data buckets. If the bucket size is
>> larger than meta_bucket_bytes(), the bcache registration can continue to
>> success, just the space more than meta_bucket_bytes() inside the bucket
>> is wasted. Comparing bcache failed for large bucket size, wasting some
>> space for meta data buckets is acceptable at this moment.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>   drivers/md/bcache/bcache.h | 20 ++++++++++++++++++++
>>   drivers/md/bcache/super.c  |  3 +++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 80e3c4813fb0..972f1aff0f70 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -762,6 +762,26 @@ struct bbio {
>>   #define bucket_bytes(c)        ((c)->sb.bucket_size << 9)
>>   #define block_bytes(c)        ((c)->sb.block_size << 9)
>>   +static inline unsigned int meta_bucket_pages(struct cache_sb *sb)
>> +{
>> +    unsigned int n, max_pages;
>> +
>> +    max_pages = min_t(unsigned int,
>> +              __rounddown_pow_of_two(USHRT_MAX) / PAGE_SECTORS,
>> +              MAX_ORDER_NR_PAGES);
>> +
>> +    n = sb->bucket_size / PAGE_SECTORS;
>> +    if (n > max_pages)
>> +        n = max_pages;
>> +
>> +    return n;
>> +}
>> +
>> +static inline unsigned int meta_bucket_bytes(struct cache_sb *sb)
>> +{
>> +    return meta_bucket_pages(sb) << PAGE_SHIFT;
>> +}
>> +
>>   #define prios_per_bucket(c)                \
>>       ((bucket_bytes(c) - sizeof(struct prio_set)) /    \
>>        sizeof(struct bucket_disk))
> I'm not particular happy with the division followed by a shift; might be
> an idea to replace the division by a shift.
> 
> But that's minor, so:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

This is from existing bcache code, let me think how to improve in future.

Thanks.

Coly Li

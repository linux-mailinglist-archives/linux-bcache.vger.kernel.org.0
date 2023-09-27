Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA417B04AF
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Sep 2023 14:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjI0Mwa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Sep 2023 08:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjI0Mwa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2023 08:52:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9C8C0
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2023 05:52:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0A4411F38C;
        Wed, 27 Sep 2023 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695819147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1G6fIm/KlMI7bJdx5AhdVJwRmDXVv7osQ7QYfQxn4k=;
        b=jeWFpwo6LEVdZql5INqlOMXdLOveK9fQeoUwCElbzGlS5jyn/dEVylSsE5pBnIRlhiJqxI
        yFEIUt1m94FH7/oWp1C8fLtbc71Nz55ctBus00cE1cAkmohfCRIRm41PcqHZEzsN/kyk3O
        eQYTV7nAMH6aKVKSxrABEkKM21/rsmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695819147;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1G6fIm/KlMI7bJdx5AhdVJwRmDXVv7osQ7QYfQxn4k=;
        b=GQe2L/BBAR+EJnbr/a2NPjKD30VqHE4k1WnzG32Kmhd9jC99cIDhe+kg41+Iok8PwqUWZF
        3RnDpY3Cn1sGdlBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CDCC013479;
        Wed, 27 Sep 2023 12:52:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BvWVI4klFGUtDQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 27 Sep 2023 12:52:25 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: Unusual value of optimal_io_size prevents bcache initialization
From:   Coly Li <colyli@suse.de>
In-Reply-To: <cfaa794e-e1b4-b014-c018-4e72457f554f@ewheeler.net>
Date:   Wed, 27 Sep 2023 20:52:13 +0800
Cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE095AA2-3C94-462F-A933-8E722FCBA12D@suse.de>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
 <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
 <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com>
 <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
 <C02D29AF-02FB-4814-A387-E78E2CB52872@suse.de>
 <cfaa794e-e1b4-b014-c018-4e72457f554f@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B49=E6=9C=8827=E6=97=A5 04:53=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 26 Sep 2023, Coly Li wrote:
>>> 2023=E5=B9=B49=E6=9C=8824=E6=97=A5 22:06=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>=20
>> [snipped]
>>=20
>>>>> Maybe bcache should not directly use q->limits.io_opt as =
d->stripe_size,
>>>>> it should be some value less than 1<<31 and aligned to =
optimal_io_size.
>>>>> After the code got merged into kernel for 10+ years, it is time to =
improve
>>>>> this calculation :-) >
>>>> Yeah, one of the other doubts I had was exactly regarding this =
value and if it is still "actual" to calculate it that way. =
Unfortunately, I don't have the expertise to have an opinion on it. =
Would you be so kind to share your knowledge and let me understand why =
it is calculated this way and why is it using the optimal io size? Is it =
using it to "writeback" optimal-sized blokes?
>>>>=20
>>>=20
>>> Most of the conditions when underlying hardware doesn=E2=80=99t =
declare its optimal io size, bcache uses 1<<31 as a default stripe size. =
It works fine for decade, so I will use it and make sure it is aligned =
to value of optimal io size. It should work fine. And I will compose a =
simple patch for this fix.
>>>=20
>>>>>> Another consideration, stripe_sectors_dirty and =
full_dirty_stripes, the two
>>>>>> arrays allocated using n, are being used just in writeback mode, =
is this
>>>>>> correct? In my specific case, I'm not planning to use writeback =
mode so I
>>>>>> would expect bcache to not even try to create those arrays. Or, =
at least, to
>>>>>> not create them during initialization but just in case of a =
change in the
>>>>>> working mode (i.e. write-through -> writeback).
>>>>> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch =
for this
>>>>> idea, but it is blocked by other depending patches which are not =
finished
>>>>> by me. Yes I like the idea to dynamically allocate/free =
d->stripe_sectors_dirty
>>>>> and d->full_dirty_stripes when they are necessary. I hope I may =
help to make
>>>>> the change go into upstream sooner.
>>>>> I will post a patch for your testing.
>>>> This would be great! Thank you very much! On the other side, if =
there's anything I can do to help I would be glad to contribute.
>>>=20
>>> I will post a simple patch for the reported memory allocation =
failure for you to test soon.
>>=20
>>=20
>> Hi Andrea,
>>=20
>> Could you please try the attached patch and see whether it makes some =
difference? Thank you in advance.
>=20
>> From: Coly Li <colyli@suse.de>
>> Date: Tue, 26 Sep 2023 20:13:19 +0800
>> Subject: [PATCH] bcache: avoid oversize memory allocation by small =
stripe_size
>>=20
>> Arraies bcache->stripe_sectors_dirty and bcache->full_dirty_stripes =
are
>> used for dirty data writeback, their sizes are decided by backing =
device
>> capacity and stripe size. Larger backing device capacity or smaller
>> stripe size make these two arraies occupies more dynamic memory =
space.
>>=20
>> Currently bcache->stripe_size is directly inherited from
>> queue->limits.io_opt of underlying storage device. For normal hard
>> drives, its limits.io_opt is 0, and bcache sets the corresponding
>> stripe_size to 1TB (1<<31 sectors), it works fine 10+ years. But for
>> devices do declare value for queue->limits.io_opt, small stripe_size
>> (comparing to 1TB) becomes an issue for oversize memory allocations =
of
>> bcache->stripe_sectors_dirty and bcache->full_dirty_stripes, while =
the
>> capacity of hard drives gets much larger in recent decade.
>>=20
>> For example a raid5 array assembled by three 20TB hardrives, the raid
>> device capacity is 40TB with typical 512KB limits.io_opt. After the =
math
>> calculation in bcache code, these two arraies will occupy 400MB =
dynamic
>> memory. Even worse Andrea Tomassetti reports that a 4KB limits.io_opt =
is
>> declared on a new 2TB hard drive, then these two arraies request 2GB =
and
>> 512MB dynamic memory from kzalloc(). The result is that bcache device
>> always fails to initialize on his system.
>>=20
>> To avoid the oversize memory allocation, bcache->stripe_size should =
not
>> directly inherited by queue->limits.io_opt from the underlying =
device.
>> This patch defines BCH_MIN_STRIPE_SZ (4MB) as minimal bcache stripe =
size
>> and set bcache device's stripe size against the declared =
limits.io_opt
>> value from the underlying storage device,
>> - If the declared limits.io_opt > BCH_MIN_STRIPE_SZ, bcache device =
will
>>  set its stripe size directly by this limits.io_opt value.
>> - If the declared limits.io_opt < BCH_MIN_STRIPE_SZ, bcache device =
will
>>  set its stripe size by a value multiplying limits.io_opt and euqal =
or
>>  large than BCH_MIN_STRIPE_SZ.
>>=20
>> Then the minimal stripe size of a bcache device will always be >=3D =
4MB.
>> For a 40TB raid5 device with 512KB limits.io_opt, memory occupied by
>> bcache->stripe_sectors_dirty and bcache->full_dirty_stripes will be =
50MB
>> in total. For a 2TB hard drive with 4KB limits.io_opt, memory =
occupied
>> by these two arraies will be 2.5MB in total.
>=20
> This will create expensive unaligned writes on RAID5/6 arrays for most
> cases.  For example, if the stripe size of 6 disks with 64 k chunks =
has
> a size of 384 k, then when you round up to an even value of 4MB
> you will introduce a read-copy-write behavior since 384KB
> does not divide evenly into 4MB (4MB/384KB =3D~ 10.667).
>=20
> The best way to handle this would be to Use 4 megabytes as a minimum,
> but round up to a multiple of the value in limits.io_opt.
>=20
> Here is a real-world example of a non-power-of-2 io_opt value:
>=20
> ]# cat /sys/block/sdc/queue/optimal_io_size=20
> 196608

Thanks for the information. This is new for me to learn :-)

Yes, you are correct here, and non-power-of-2 is better.

>=20
> More below:
>=20
>> Such mount of memory allocated for bcache->stripe_sectors_dirty and
>> bcache->full_dirty_stripes is reasonable for most of storage devices.
>>=20
>> Reported-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Eric Wheeler <bcache@lists.ewheeler.net>
>> ---
>> drivers/md/bcache/bcache.h | 1 +
>> drivers/md/bcache/super.c  | 2 ++
>> 2 files changed, 3 insertions(+)
>>=20
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 5a79bb3c272f..83eb7f27db3d 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -265,6 +265,7 @@ struct bcache_device {
>> #define BCACHE_DEV_WB_RUNNING 3
>> #define BCACHE_DEV_RATE_DW_RUNNING 4
>> int nr_stripes;
>> +#define BCH_MIN_STRIPE_SZ ((4 << 20) >> SECTOR_SHIFT)
>> unsigned int stripe_size;
>> atomic_t *stripe_sectors_dirty;
>> unsigned long *full_dirty_stripes;
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 0ae2b3676293..0eb71543d773 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -905,6 +905,8 @@ static int bcache_device_init(struct =
bcache_device *d, unsigned int block_size,
>>=20
>> if (!d->stripe_size)
>> d->stripe_size =3D 1 << 31;
>> + else if (d->stripe_size < BCH_MIN_STRIPE_SZ)
>> + d->stripe_size =3D round_up(BCH_MIN_STRIPE_SZ, d->stripe_size);
>=20
> I think you want "roundup" (not "round_up") to solve alignment =
problem:
>=20
> + d->stripe_size =3D roundup(BCH_MIN_STRIPE_SZ, d->stripe_size);
>=20
> Both roundup() and round_up() are defined in math.h:
>=20
>  * round_up - round up to next specified power of 2
>  * roundup - round up to the next specified multiple=20
>=20
> https://elixir.bootlin.com/linux/v6.0/source/include/linux/math.h#L17


Sure I will use your suggestion in next version.

Thanks again :-)

Coly Li



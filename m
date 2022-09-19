Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4545E5BCB9F
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiISMRJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 08:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiISMRI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 08:17:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B7DF16
        for <linux-bcache@vger.kernel.org>; Mon, 19 Sep 2022 05:17:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3D3381F897;
        Mon, 19 Sep 2022 12:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663589824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMT/sXZ4NKLISK9kD5RbHiDTRUTKAiIBEBELxPtvDmI=;
        b=Lu15I5Pccwu2PEFd988kd+1mwKG8iHf3ef0BV1qqyZmUbPHxGLkEaHMJG2s95UZ+9yz6ya
        WLvZ2MRCza2duQseRxwE9VFbjVL3Jzjb1MPnvmzJ49FwSWtMV38727XRU4UR+nTUq990oF
        kaBeN92BoKsNstvknXh8jGC6ji4a5d4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663589824;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMT/sXZ4NKLISK9kD5RbHiDTRUTKAiIBEBELxPtvDmI=;
        b=fQTTIaFDUBRR+T/2YplXnXMAGUKK5REzW0hkIZRB5qGpJZCbcjyOrd+cFPj/JUGHdI6h4R
        m7zy4QVbo7WRD/Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7574213ABD;
        Mon, 19 Sep 2022 12:17:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WPVfDr5dKGNnJAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 19 Sep 2022 12:17:02 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <14c2bdbd-e4ae-a5d1-3947-6ea6dc29f0bc@devo.com>
Date:   Mon, 19 Sep 2022 20:16:59 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E8AC75B3-1BAD-4AD8-AD77-ADE8A2E9E8C6@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <14c2bdbd-e4ae-a5d1-3947-6ea6dc29f0bc@devo.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8819=E6=97=A5 19:42=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> have you had any time to take a look at this? Do you prefer if I send =
the patch as a separate thread?
>=20
> Thank you very much,
> Andrea


Yes, it is on my queue, just after I finish my tasks on hand, I will =
take a look on it.

Thanks.

Coly Li


>=20
> On 8/9/22 10:32, Andrea Tomassetti wrote:
>> =46rom 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 =
2001
>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
>> Date: Thu, 8 Sep 2022 09:47:55 +0200
>> Subject: [PATCH] bcache: Add support for live resize of backing =
devices
>> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>> ---
>> Hi Coly,
>> Here is the first version of the patch. There are some points I noted =
down
>> that I would like to discuss with you:
>>  - I found it pretty convenient to hook the call of the new added =
function
>>    inside the `register_bcache`. In fact, every time (at least from =
my
>>    understandings) a disk changes size, it will trigger a new probe =
and,
>>    thus, `register_bcache` will be triggered. The only inconvenient
>>    is that, in case of success, the function will output
>>    `error: capacity changed` even if it's not really an error.
>>  - I'm using `kvrealloc`, introduced in kernel version 5.15, to =
resize
>>    `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
>>    problem, right?
>>  - There is some reused code between this new function and
>>    `bcache_device_init`. Maybe I can move `const size_t max_stripes` =
to
>>    a broader scope or make it a macro, what do you think?
>> Thank you very much,
>> Andrea
>>  drivers/md/bcache/super.c | 75 =
++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 74 insertions(+), 1 deletion(-)
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index ba3909bb6bea..9a77caf2a18f 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
>>      return bch_is_open_cache(dev) || bch_is_open_backing(dev);
>>  }
>> +static bool bch_update_capacity(dev_t dev)
>> +{
>> +    const size_t max_stripes =3D min_t(size_t, INT_MAX,
>> +                     SIZE_MAX / sizeof(atomic_t));
>> +
>> +    uint64_t n, n_old;
>> +    int nr_stripes_old;
>> +    bool res =3D false;
>> +
>> +    struct bcache_device *d;
>> +    struct cache_set *c, *tc;
>> +    struct cached_dev *dcp, *t, *dc =3D NULL;
>> +
>> +    uint64_t parent_nr_sectors;
>> +
>> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
>> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
>> +            if (dcp->bdev->bd_dev =3D=3D dev) {
>> +                dc =3D dcp;
>> +                goto dc_found;
>> +            }
>> +
>> +dc_found:
>> +    if (!dc)
>> +        return false;
>> +
>> +    parent_nr_sectors =3D bdev_nr_sectors(dc->bdev) - =
dc->sb.data_offset;
>> +
>> +    if (parent_nr_sectors =3D=3D =
bdev_nr_sectors(dc->disk.disk->part0))
>> +        return false;
>> +
>> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
>> +        return false;
>> +
>> +    d =3D &dc->disk;
>> +
>> +    /* Force cached device sectors re-calc */
>> +    calc_cached_dev_sectors(d->c);
>> +
>> +    /* Block writeback thread */
>> +    down_write(&dc->writeback_lock);
>> +    nr_stripes_old =3D d->nr_stripes;
>> +    n =3D DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
>> +    if (!n || n > max_stripes) {
>> +        pr_err("nr_stripes too large or invalid: %llu (start sector =
beyond end of disk?)\n",
>> +            n);
>> +        goto unblock_and_exit;
>> +    }
>> +    d->nr_stripes =3D n;
>> +
>> +    n =3D d->nr_stripes * sizeof(atomic_t);
>> +    n_old =3D nr_stripes_old * sizeof(atomic_t);
>> +    d->stripe_sectors_dirty =3D kvrealloc(d->stripe_sectors_dirty, =
n_old,
>> +        n, GFP_KERNEL);
>> +    if (!d->stripe_sectors_dirty)
>> +        goto unblock_and_exit;
>> +
>> +    n =3D BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>> +    n_old =3D BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
>> +    d->full_dirty_stripes =3D kvrealloc(d->full_dirty_stripes, =
n_old, n, GFP_KERNEL);
>> +    if (!d->full_dirty_stripes)
>> +        goto unblock_and_exit;
>> +
>> +    res =3D true;
>> +
>> +unblock_and_exit:
>> +    up_write(&dc->writeback_lock);
>> +    return res;
>> +}
>> +
>>  struct async_reg_args {
>>      struct delayed_work reg_work;
>>      char *path;
>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject =
*k, struct kobj_attribute *attr,
>>              mutex_lock(&bch_register_lock);
>>              if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
>>                  bch_is_open(dev))
>> -                err =3D "device already registered";
>> +                if (bch_update_capacity(dev))
>> +                    err =3D "capacity changed";
>> +                else
>> +                    err =3D "device already registered";
>>              else
>>                  err =3D "device busy";
>>              mutex_unlock(&bch_register_lock);
>> --=20
>> 2.37.3
>> On 6/9/22 15:22, Andrea Tomassetti wrote:
>>> Hi Coly,
>>> I have finally some time to work on the patch. I already have a =
first
>>> prototype that seems to work but, before sending it, I would like to
>>> ask you two questions:
>>>    1. Inspecting the code, I found that the only lock mechanism is =
the
>>> writeback_lock semaphore. Am I correct?
>>>    2. How can I effectively test my patch? So far I'm doing =
something like this:
>>>       a. make-bcache --writeback -B /dev/vdb -C /dev/vdc
>>>       b. mkfs.xfs /dev/bcache0
>>>       c. dd if=3D/dev/random of=3D/mnt/random bs=3D1M count=3D1000
>>>       d. md5sum /mnt/random | tee /mnt/random.md5
>>>       e. live resize the disk and repeat c. and d.
>>>       f. umount/reboot/remount and check that the md5 hashes are =
correct
>>>=20
>>> Any suggestions?
>>>=20
>>> Thank you very much,
>>> Andrea
>>>=20
>>> On Fri, Aug 5, 2022 at 9:38 PM Eric Wheeler =
<bcache@lists.ewheeler.net> wrote:
>>>>=20
>>>> On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
>>>>> Hi Coly,
>>>>> In one of our previous emails you said that
>>>>>> Currently bcache doesn=E2=80=99t support cache or backing device =
resize
>>>>>=20
>>>>> I was investigating this point and I actually found a solution. I
>>>>> briefly tested it and it seems to work fine.
>>>>> Basically what I'm doing is:
>>>>>    1. Check if there's any discrepancy between the nr of sectors
>>>>> reported by the bcache backing device (holder) and the nr of =
sectors
>>>>> reported by its parent (slave).
>>>>>    2. If the number of sectors of the two devices are not the =
same,
>>>>> then call set_capacity_and_notify on the bcache device.
>>>>>    3. =46rom user space, depending on the fs used, grow the fs =
with some
>>>>> utility (e.g. xfs_growfs)
>>>>>=20
>>>>> This works without any need of unmounting the mounted fs nor =
stopping
>>>>> the bcache backing device.
>>>>=20
>>>> Well done! +1, would love to see a patch for this!
>>>>=20
>>>>=20
>>>>> So my question is: am I missing something? Can this live resize =
cause
>>>>> some problems (e.g. data loss)? Would it be useful if I send a =
patch on
>>>>> this?
>>>>=20
>>>> A while a go we looked into doing this.  Here is the summary of our
>>>> findings, not sure if there are any other considerations:
>>>>=20
>>>>    1. Create a sysfs file like /sys/block/bcache0/bcache/resize to =
trigger
>>>>       resize on echo 1 >.
>>>>    2. Refactor the set_capacity() bits from  bcache_device_init() =
into its
>>>>       own function.
>>>>    3. Put locks around bcache_device.full_dirty_stripes and
>>>>       bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and =
zero the
>>>>       new bytes at the end.  Grep where =
bcache_device.full_dirty_stripes is
>>>>       used and make sure it is locked appropriately, probably in =
the
>>>>       writeback thread, maybe other places too.
>>>>=20
>>>> The cachedev's don't know anything about the bdev size, so =
(according to
>>>> Kent) they will "just work" by referencing new offsets that were
>>>> previously beyond the disk. (This is basically the same as resizing =
the
>>>> bdev and then unregister/re-register which is how we resize bdevs =
now.)
>>>>=20
>>>> As for resizing a cachedev, I've not looked at all---not sure about =
that
>>>> one.  We always detach, resize, make-bcache and re-attach the new =
cache.
>>>> Maybe it is similarly simple, but haven't looked.
>>>>=20
>>>>=20
>>>> --=20
>>>> Eric Wheeler
>>>>=20
>>>>=20
>>>>=20
>>>>>=20
>>>>> Kind regards,
>>>>> Andrea
>>>>>=20


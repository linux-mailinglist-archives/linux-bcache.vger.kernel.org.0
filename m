Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E903766E344
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Jan 2023 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjAQQSz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 17 Jan 2023 11:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjAQQSz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 17 Jan 2023 11:18:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCE93BDBF
        for <linux-bcache@vger.kernel.org>; Tue, 17 Jan 2023 08:18:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E8FD23891F;
        Tue, 17 Jan 2023 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673972331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWv5QVuK4hguB7lelP7G47RJ1hnbwkkvAnSZSO+qKbw=;
        b=og6wsu61YNorQYAQO3iEvbsnp/JhtmzjFQmkAtxz6ZkC0ybljVCXa1OixBvkl1Z1nAb5OY
        52FnBiBkjhyvO/LQh4t9GB1KfAwoZTLq3bA5UPi5IJ/qPX/sV1e2SCgspfTDkibFB31f07
        vzVvsYiJgEml7lmXAZXjd5WQHGqjd5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673972331;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWv5QVuK4hguB7lelP7G47RJ1hnbwkkvAnSZSO+qKbw=;
        b=h0VyYpCE0YIFb8tOAKDCf0fSeII99RnXHi+zWuxuoZmo/uw3RPViULRPGrC/9jyMujbwAZ
        pRIOfunYDQZWFtAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E77BD13357;
        Tue, 17 Jan 2023 16:18:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /bstLWrKxmP4aAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 17 Jan 2023 16:18:50 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
Date:   Wed, 18 Jan 2023 00:18:38 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=8812=E6=97=A5 00:01=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> thank you for taking the time to reply, I really hope you are feeling
> better now.

Thanks. But the recovery is really slow, and my response cannot be in =
time. I was told it might be better after 1 month, hope it is true.

>=20
> On Fri, Dec 30, 2022 at 11:41 AM Coly Li <colyli@suse.de> wrote:
>>=20
>> On 9/8/22 4:32 PM, Andrea Tomassetti wrote:
>>> =46rom 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 =
2001
>>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
>>> Date: Thu, 8 Sep 2022 09:47:55 +0200
>>> Subject: [PATCH] bcache: Add support for live resize of backing =
devices
>>>=20
>>> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>>=20
>> Hi Andrea,
>>=20
>> I am just recovered from Omicron, and able to reply email. Let me =
place
>> my comments inline.
>>=20
>>=20
>>> ---
>>> Hi Coly,
>>> Here is the first version of the patch. There are some points I =
noted
>>> down
>>> that I would like to discuss with you:
>>> - I found it pretty convenient to hook the call of the new added
>>> function
>>>   inside the `register_bcache`. In fact, every time (at least from =
my
>>>   understandings) a disk changes size, it will trigger a new probe =
and,
>>>   thus, `register_bcache` will be triggered. The only inconvenient
>>>   is that, in case of success, the function will output
>>=20
>> The resize should be triggered manually, and not to do it =
automatically.
>>=20
>> You may create a sysfs file under the cached device's directory, name =
it
>> as "extend_size" or something else you think better.
>>=20
>> Then the sysadmin may extend the cached device size explicitly on a
>> predictable time.
>>=20
>>> `error: capacity changed` even if it's not really an error.
>>> - I'm using `kvrealloc`, introduced in kernel version 5.15, to =
resize
>>>   `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
>>>   problem, right?
>>> - There is some reused code between this new function and
>>>   `bcache_device_init`. Maybe I can move `const size_t max_stripes` =
to
>>>   a broader scope or make it a macro, what do you think?
>>>=20
>>> Thank you very much,
>>> Andrea
>>>=20
>>> drivers/md/bcache/super.c | 75 =
++++++++++++++++++++++++++++++++++++++-
>>> 1 file changed, 74 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index ba3909bb6bea..9a77caf2a18f 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
>>> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
>>>     return bch_is_open_cache(dev) || bch_is_open_backing(dev);
>>> }
>>>=20
>>> +static bool bch_update_capacity(dev_t dev)
>>> +{
>>> +    const size_t max_stripes =3D min_t(size_t, INT_MAX,
>>> +                     SIZE_MAX / sizeof(atomic_t));
>>> +
>>> +    uint64_t n, n_old;
>>> +    int nr_stripes_old;
>>> +    bool res =3D false;
>>> +
>>> +    struct bcache_device *d;
>>> +    struct cache_set *c, *tc;
>>> +    struct cached_dev *dcp, *t, *dc =3D NULL;
>>> +
>>> +    uint64_t parent_nr_sectors;
>>> +
>>> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
>>> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
>>> +            if (dcp->bdev->bd_dev =3D=3D dev) {
>>> +                dc =3D dcp;
>>> +                goto dc_found;
>>> +            }
>>> +
>>> +dc_found:
>>> +    if (!dc)
>>> +        return false;
>>> +
>>> +    parent_nr_sectors =3D bdev_nr_sectors(dc->bdev) - =
dc->sb.data_offset;
>>> +
>>> +    if (parent_nr_sectors =3D=3D =
bdev_nr_sectors(dc->disk.disk->part0))
>>> +        return false;
>>> +
>>=20
>> The above code only handles whole disk using as cached device. If a
>> partition of a hard drive is used as cache device, and there are =
other
>> data after this partition, such condition should be handled as well. =
So
>> far I am fine to only extend size when using the whole hard drive as
>> cached device, but more code is necessary to check and only permits
>> size-extend for such condition.
> I don't understand if there's a misalignment here so let me be more
> clear: this patch is intended to support the live resize of *backing
> devices*, is this what you mean with "cached device"?

Yes, backing device is cached device.


> When I was working on the patch I didn't consider the possibility of
> live resizing the cache devices, but it should be trivial.
> So, as far as I understand, a partition cannot be used as a backing
> device, correct? The whole disk should be used as a backing device,
> that's why I'm checking and that's why this check should be correct.
> Am I wrong?

Yes a partition can be used as a backing (cached) device.
That is to say, if a file system is format on top of the cached device, =
this file system cannot be directly accessed via the partition. It has =
to be accessed via the bcache device e.g. /dev/bcache0.


>=20
>>=20
>>> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
>>> +        return false;
>>=20
>> The above code should be done when all rested are set.
>>=20
>>=20
>>> +
>>> +    d =3D &dc->disk;
>>> +
>>> +    /* Force cached device sectors re-calc */
>>> +    calc_cached_dev_sectors(d->c);
>>=20
>> Here c->cached_dev_sectors might be changed, if any of the following
>> steps fails, it should be restored to previous value.
>>=20
>>=20
>>> +
>>> +    /* Block writeback thread */
>>> +    down_write(&dc->writeback_lock);
>>> +    nr_stripes_old =3D d->nr_stripes;
>>> +    n =3D DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
>>> +    if (!n || n > max_stripes) {
>>> +        pr_err("nr_stripes too large or invalid: %llu (start sector
>>> beyond end of disk?)\n",
>>> +            n);
>>> +        goto unblock_and_exit;
>>> +    }
>>> +    d->nr_stripes =3D n;
>>> +
>>> +    n =3D d->nr_stripes * sizeof(atomic_t);
>>> +    n_old =3D nr_stripes_old * sizeof(atomic_t);
>>> +    d->stripe_sectors_dirty =3D kvrealloc(d->stripe_sectors_dirty, =
n_old,
>>> +        n, GFP_KERNEL);
>>> +    if (!d->stripe_sectors_dirty)
>>> +        goto unblock_and_exit;
>>> +
>>> +    n =3D BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>>> +    n_old =3D BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned =
long);
>>> +    d->full_dirty_stripes =3D kvrealloc(d->full_dirty_stripes, =
n_old,
>>> n, GFP_KERNEL);
>>> +    if (!d->full_dirty_stripes)
>>> +        goto unblock_and_exit;
>>=20
>> If kvrealloc() fails and NULL set to d->full_dirty_sripes, the =
previous
>> array should be restored.
>>=20
>>> +
>>> +    res =3D true;
>>> +
>>> +unblock_and_exit:
>>> +    up_write(&dc->writeback_lock);
>>> +    return res;
>>> +}
>>> +
>>=20
>> I didn't test the patch, from the first glance, I feel the failure
>> handling should restore all previous values, otherwise the cache =
device
>> may be in a non-consistent state when extend size fails.
>>=20
> Completely agree with you on this point. I changed it locally and, as
> soon as we agree on the other points I'll send a newer version of the
> patch.
>>=20
>>> struct async_reg_args {
>>>     struct delayed_work reg_work;
>>>     char *path;
>>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject
>>> *k, struct kobj_attribute *attr,
>>>             mutex_lock(&bch_register_lock);
>>>             if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
>>>                 bch_is_open(dev))
>>> -                err =3D "device already registered";
>>> +                if (bch_update_capacity(dev))
>>> +                    err =3D "capacity changed";
>>> +                else
>>> +                    err =3D "device already registered";
>>=20
>>=20
>> As I said, it should be a separated write-only sysfile under the =
cache
>> device's directory.
> Can I ask why you don't like the automatic resize way? Why should the
> resize be manual?

Most of system administrators don=E2=80=99t like such silently automatic =
things. They want to extend the size explicitly, especially when there =
is other dependences in their configurations.


> Someone needs to trigger the block device resize, so shouldn't that be =
enough?

Yes, an explicit write operation on a sysfs file to trigger the resize. =
Then we can permit people to do the size extend explicit and avoid to =
change current behavior.

Thanks.

Coly Li

>=20
> Andrea
>>=20
>>=20
>>> else
>>>                 err =3D "device busy";
>>>             mutex_unlock(&bch_register_lock);
>>> --
>>> 2.37.3
>>>=20
>>=20


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0AD5AE969
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Sep 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbiIFNXN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Sep 2022 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240036AbiIFNXL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Sep 2022 09:23:11 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1EC70E6C
        for <linux-bcache@vger.kernel.org>; Tue,  6 Sep 2022 06:23:08 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c9so8076148qkk.6
        for <linux-bcache@vger.kernel.org>; Tue, 06 Sep 2022 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ynTH3ckNBGQWCeL4CO8n6V4kuNH5UVjkZS48J4hKXrc=;
        b=SKZDj2BP/6u4los3m0BhAHnpRsCNsqtmWiMAXgGBqyhANu3pLX+HmTz6QARd5ebWPi
         lvMfmkgABGaC0/pDZPJODjRBlq1nC91iGFMoeW6b2R41WDHjcN06YM86ht2M7sczC4Ip
         BzKpgpOwkxBglm/jQysN2y/UYvAzALPYlr13noNv4H1Md/o1v6H2sabao0QEHM8CACDo
         yaSaHYFMgu4X/KYWycRyafCWs5Z6uSGfHCCvWcH4dinRq6kw0bSrH3HsVp/b3ZxZtPvZ
         bXW5PWKH0O4yVFdEBVZV6XOYhtNUia/ccqpTH56+3j8VXqCgg/d7+ZKQK9s7cR4AcUZb
         suiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ynTH3ckNBGQWCeL4CO8n6V4kuNH5UVjkZS48J4hKXrc=;
        b=gzYrvwF+FxqBJkHuzz06i6jNpMh0MMW8j5KUj+cqeOOktALSLGbpne8OfvpdfYV/L9
         af0QXV9XVEYUCc1XCunpw12BYnzKxKoqsqiTRMT2WvGyUNcMSNBd4uwa4BZXsQMlGoKx
         Iu7yPqO/RhA34Q2dl6DE/m4ICGzAkmxS7vFL+zV2sDJF0wwYHOMDroJyr5HQABG4PDyS
         o6L3xIG9kw2DqWpk44ZHG5mAQIzy7C7S3Y0aJfSqml6V6MEQBljuMskim76/lgtHdpL2
         gELfYmNEXHcdDihiux0Kf1seHqD7ReZEfY45fbgOP6s6T0dGypLa1KRZE3U2N7gL15rA
         9kww==
X-Gm-Message-State: ACgBeo2xzRKJ0q0XkvTBxHefBnleHk324mb2XfqD9b3skBjwWApAZTj2
        TxKLOGy4h+Rb8d/9L3SYxYxSOaBhdygXx0Vt7qmr/IH/YNic+Zjn
X-Google-Smtp-Source: AA6agR5ufwq1eHcwcMgNU+mLMuhcBKQSgfF80L7C495xdlP3XmGtsuNJjbjW/nNlNJ9vVrcnYHxZ5YKb91g8GWkjZ1Y=
X-Received: by 2002:a05:620a:2591:b0:6c9:cc85:87e3 with SMTP id
 x17-20020a05620a259100b006c9cc8587e3mr785559qko.577.1662470587616; Tue, 06
 Sep 2022 06:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
In-Reply-To: <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Tue, 6 Sep 2022 15:22:56 +0200
Message-ID: <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
Subject: Re: [RFC] Live resize of backing device
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
I have finally some time to work on the patch. I already have a first
prototype that seems to work but, before sending it, I would like to
ask you two questions:
  1. Inspecting the code, I found that the only lock mechanism is the
writeback_lock semaphore. Am I correct?
  2. How can I effectively test my patch? So far I'm doing something like t=
his:
     a. make-bcache --writeback -B /dev/vdb -C /dev/vdc
     b. mkfs.xfs /dev/bcache0
     c. dd if=3D/dev/random of=3D/mnt/random bs=3D1M count=3D1000
     d. md5sum /mnt/random | tee /mnt/random.md5
     e. live resize the disk and repeat c. and d.
     f. umount/reboot/remount and check that the md5 hashes are correct

Any suggestions?

Thank you very much,
Andrea

On Fri, Aug 5, 2022 at 9:38 PM Eric Wheeler <bcache@lists.ewheeler.net> wro=
te:
>
> On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
> > Hi Coly,
> > In one of our previous emails you said that
> > > Currently bcache doesn=E2=80=99t support cache or backing device resi=
ze
> >
> > I was investigating this point and I actually found a solution. I
> > briefly tested it and it seems to work fine.
> > Basically what I'm doing is:
> >   1. Check if there's any discrepancy between the nr of sectors
> > reported by the bcache backing device (holder) and the nr of sectors
> > reported by its parent (slave).
> >   2. If the number of sectors of the two devices are not the same,
> > then call set_capacity_and_notify on the bcache device.
> >   3. From user space, depending on the fs used, grow the fs with some
> > utility (e.g. xfs_growfs)
> >
> > This works without any need of unmounting the mounted fs nor stopping
> > the bcache backing device.
>
> Well done! +1, would love to see a patch for this!
>
>
> > So my question is: am I missing something? Can this live resize cause
> > some problems (e.g. data loss)? Would it be useful if I send a patch on
> > this?
>
> A while a go we looked into doing this.  Here is the summary of our
> findings, not sure if there are any other considerations:
>
>   1. Create a sysfs file like /sys/block/bcache0/bcache/resize to trigger
>      resize on echo 1 >.
>   2. Refactor the set_capacity() bits from  bcache_device_init() into its
>      own function.
>   3. Put locks around bcache_device.full_dirty_stripes and
>      bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and zero the
>      new bytes at the end.  Grep where bcache_device.full_dirty_stripes i=
s
>      used and make sure it is locked appropriately, probably in the
>      writeback thread, maybe other places too.
>
> The cachedev's don't know anything about the bdev size, so (according to
> Kent) they will "just work" by referencing new offsets that were
> previously beyond the disk. (This is basically the same as resizing the
> bdev and then unregister/re-register which is how we resize bdevs now.)
>
> As for resizing a cachedev, I've not looked at all---not sure about that
> one.  We always detach, resize, make-bcache and re-attach the new cache.
> Maybe it is similarly simple, but haven't looked.
>
>
> --
> Eric Wheeler
>
>
>
> >
> > Kind regards,
> > Andrea
> >

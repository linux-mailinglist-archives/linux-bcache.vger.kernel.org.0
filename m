Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968D589D85
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Aug 2022 16:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiHDOcx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Aug 2022 10:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiHDOcx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Aug 2022 10:32:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224F147BA6
        for <linux-bcache@vger.kernel.org>; Thu,  4 Aug 2022 07:32:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C728E4E5BC;
        Thu,  4 Aug 2022 14:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659623570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UD0hMm92jhru91m3TH4It/9e/gspYu+rZJp9kVfCArM=;
        b=UbGknMGknDiMR/FzVgDfdX4nFsqZPJv4txQwvyLG3NiR3mosO9Z9fbxcB6jEpyN3ALiMgT
        78RRQZEqQcQSi8um4+k0vJj3yUYo7X6bc5iIksdZMM7wD1hGv7F6cIvQL7d4PF4K72AnDf
        kkMJHhib95IVvVUePkELlmgk4aY3Rc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659623570;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UD0hMm92jhru91m3TH4It/9e/gspYu+rZJp9kVfCArM=;
        b=3eYjV5KioHQqHTegx7uXP8KPr7dvCwTFuBH+hxypZt7+ErXg5BnyMol2HIwGwaCLfn9O+h
        6zsVSTXsJ7CIakBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBE7813A94;
        Thu,  4 Aug 2022 14:32:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DVWYHpHY62JreAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 04 Aug 2022 14:32:49 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
Date:   Thu, 4 Aug 2022 22:32:46 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <626E9340-21BC-462A-8A76-0C137DC4A8E0@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=883=E6=97=A5 18:05=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> In one of our previous emails you said that
>> Currently bcache doesn=E2=80=99t support cache or backing device =
resize
>=20
> I was investigating this point and I actually found a solution. I
> briefly tested it and it seems to work fine.
> Basically what I'm doing is:
>  1. Check if there's any discrepancy between the nr of sectors
> reported by the bcache backing device (holder) and the nr of sectors
> reported by its parent (slave).
>  2. If the number of sectors of the two devices are not the same,
> then call set_capacity_and_notify on the bcache device.
>  3. =46rom user space, depending on the fs used, grow the fs with some
> utility (e.g. xfs_growfs)
>=20
> This works without any need of unmounting the mounted fs nor stopping
> the bcache backing device.
>=20
> So my question is: am I missing something? Can this live resize cause
> some problems (e.g. data loss)? Would it be useful if I send a patch
> on this?

Hi Andrea,

It sounds good. You may look at bcache_device_init() to see how the =
following items are initialized,
- d->nr_stripes
- d->stripe_sectors_dirty
- d->full_dirty_stripes

And you may check calc_cached_dev_sectors() to see how this item is =
initilaized,
- c->cached_dev_sectors

All the above items are writeback related, when they are updated with =
the size increased, you should use proper locks to avoid potential race =
from where they are referenced in the writeback code flow (maybe =
somewhere else too).

The overall idea should work, I=E2=80=99d like to see your tested patch =
:-)

Coly Li=

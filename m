Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA86D7E39
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Apr 2023 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbjDEN6L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Apr 2023 09:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbjDEN6J (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Apr 2023 09:58:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D8CE5D
        for <linux-bcache@vger.kernel.org>; Wed,  5 Apr 2023 06:57:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0FB4A2292E;
        Wed,  5 Apr 2023 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680703077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XO1hGF1uOwQ7MJHC2gSj568PrqR6ustE+ICwBwX7h7Q=;
        b=SSF+3CXFnlH5pzAAmBeD16CetPDw6UD2VT/m5xufvclhBu2hZy6FCCwuFw7eCcYLKsqqYp
        r0ic+CBmpbLRUbIBTfwLP17WXF6hn7hg845XmC7hDZC4r120FRiJFiUT+cMfoWC0f3uOj3
        x9f1nSAdIqDbmqiTpqW6/K37ceMxfEw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680703077;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XO1hGF1uOwQ7MJHC2gSj568PrqR6ustE+ICwBwX7h7Q=;
        b=ECYOGzBD6BggEKA4zABeL6e3bLWZzyGYP5rVuo5CP9wb4ydZAU9/OeiR9n+j0NANHFrG2U
        3NK+uOxhZ2kYJoDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C481D13A31;
        Wed,  5 Apr 2023 13:57:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CXoUI2N+LWSAeQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 05 Apr 2023 13:57:55 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Writeback cache all used.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <1783117292.2943582.1680640140702@mail.yahoo.com>
Date:   Wed, 5 Apr 2023 21:57:42 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
 <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
 <1121771993.1793905.1680221827127@mail.yahoo.com>
 <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
 <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
 <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
 <1783117292.2943582.1680640140702@mail.yahoo.com>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B44=E6=9C=885=E6=97=A5 04:29=EF=BC=8CAdriano Silva =
<adriano_da_silva@yahoo.com.br> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello,
>=20
>> It sounds like a large cache size with limit memory cache=20
>> for B+tree nodes?
>=20
>> If the memory is limited and all B+tree nodes in the hot I/O=20
>> paths cannot stay in memory, it is possible for such=20
>> behavior happens. In this case, shrink the cached data=20
>> may deduce the meta data and consequential in-memory=20
>> B+tree nodes as well. Yes it may be helpful for such=20
>> scenario.
>=20
> There are several servers (TEN) all with 128 GB of RAM, of which =
around 100GB (on average) are presented by the OS as free. Cache is =
594GB in size on enterprise NVMe, mass storage is 6TB. The configuration =
on all is the same. They run Ceph OSD to service a pool of disks =
accessed by servers (others including themselves).
>=20
> All show the same behavior.
>=20
> When they were installed, they did not occupy the entire cache. =
Throughout use, the cache gradually filled up and  never decreased in =
size. I have another five servers in  another cluster going the same =
way. During the night  their workload is reduced.

Copied.

>=20
>> But what is the I/O pattern here? If all the cache space=20
>> occupied by clean data for read request, and write=20
>> performance is cared about then. Is this a write tended,=20
>> or read tended workload, or mixed?
>=20
> The workload is greater in writing. Both are important, read and =
write. But write latency is critical. These are virtual machine disks =
that are stored on Ceph. Inside we have mixed loads, Windows with =
terminal service, Linux, including a database where direct write latency =
is critical.


Copied.

>=20
>> As I explained, the re-reclaim has been here already.=20
>> But it cannot help too much if busy I/O requests always=20
>> coming and writeback and gc threads have no spare=20
>> time to perform.
>=20
>> If coming I/Os exceeds the service capacity of the=20
>> cache service window, disappointed requesters can=20
>> be expected.
>=20
> Today, the ten servers have been without I/O operation for at least 24 =
hours. Nothing has changed, they continue with 100% cache occupancy. I =
believe I should have given time for the GC, no?

This is nice. Now we have the maximum writeback thoughput after I/O idle =
for a while, so after 24 hours all dirty data should be written back and =
the whole cache might be clean.

I guess just a gc is needed here.

Can you try to write 1 to cache set sysfs file gc_after_writeback? When =
it is set, a gc will be waken up automatically after all writeback =
accomplished. Then most of the clean cache might be shunk and the B+tree =
nodes will be deduced quite a lot.


>=20
>> Let=E2=80=99s check whether it is just becasue of insuffecient=20
>> memory to hold the hot B+tree node in memory.
>=20
> Does the bcache configuration have any RAM memory reservation options? =
Or would the 100GB of RAM be insufficient for the 594GB of NVMe Cache? =
For that amount of Cache, how much RAM should I have reserved for =
bcache? Is there any command or parameter I should use to signal bcache =
that it should reserve this RAM memory? I didn't do anything about this =
matter. How would I do it?
>=20

Currently there is no such option for limit bcache in-memory B+tree =
nodes cache occupation, but when I/O load reduces, such memory =
consumption may drop very fast by the reaper from system memory =
management code. So it won=E2=80=99t be a problem. Bcache will try to =
use any possible memory for B+tree nodes cache if it is necessary, and =
throttle I/O performance to return these memory back to memory =
management code when the available system memory is low. By default, it =
should work well and nothing should be done from user.=20

> Another question: How do I know if I should trigger a TRIM (discard) =
for my NVMe with bcache?

Bcache doesn=E2=80=99t issue trim request proactively. The bcache =
program from bcache-tools may issue a discard request when you run,
	bcache make -C <cache device path>
to create a cache device.

In run time, bcache code only forward the trim request to backing device =
(not cache device).


Thanks.

Coly Li
=20

>=20
[snipped]


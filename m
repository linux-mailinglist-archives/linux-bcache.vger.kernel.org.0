Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4877AA51
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Aug 2023 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjHMR0N (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 13 Aug 2023 13:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjHMR0M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 13 Aug 2023 13:26:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCFC10FA
        for <linux-bcache@vger.kernel.org>; Sun, 13 Aug 2023 10:26:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7913321963;
        Sun, 13 Aug 2023 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691947573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRpqEFkPqQupqSBDj1WhN3rbzNDlNc/gjc5FJlYrAZw=;
        b=R7Ktg1G6GadcsZvIzf5h4qLiKV2cpsw+EqzaLW6ygmsw7paiPbxGOqulA3sprr+xaKfLvP
        TrED/RBIYwKerNvTfY24+ELs2awAciRoVdgtJnrAgABZiQEVjwUNu66M3aVPdQxSrzF1H9
        va1UgbK5hnkDs1bc74Hs1is1SXRda48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691947573;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRpqEFkPqQupqSBDj1WhN3rbzNDlNc/gjc5FJlYrAZw=;
        b=WtzxiGuqupO3POdDeyK45/R2C0pEbOA9sZAPZT5bCNHAuMSZ9yds8pO20+5AmwSOUS+8JL
        82Fh/BjAnAbtqHAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA3D01322C;
        Sun, 13 Aug 2023 17:26:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0C8EGjMS2WR9PwAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 13 Aug 2023 17:26:11 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: bcache attach
From:   Coly Li <colyli@suse.de>
In-Reply-To: <7e04d1b2-beee-447f-aad4-ea1025f44549@axxess.co.za>
Date:   Mon, 14 Aug 2023 01:22:11 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B337E0E5-5583-435C-BAB7-567AFD824BD4@suse.de>
References: <e37842e3-8b7e-4849-9974-808e8ae038fd@axxess.co.za>
 <7e04d1b2-beee-447f-aad4-ea1025f44549@axxess.co.za>
To:     Josias Wolhuter <josias@axxess.co.za>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

What is the kernel version and bcache-tools version?

Normally default setup won=E2=80=99t trigger this situation, what is the =
set=E2=80=99s block size and the backing device block size on your =
setup?

Coly Li

> 2023=E5=B9=B48=E6=9C=8812=E6=97=A5 04:34=EF=BC=8CJosias Wolhuter =
<josias@axxess.co.za> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> ah. I see from dmesg
> [ 8872.792317] bcache: bch_cached_dev_attach() Couldn't attach sdb1: =
block size less than set's block size
> [ 8872.792323] bcache: __cached_dev_store() Can't attach =
b43b13cf-32b1-4e5a-af7d-27b6d246662d
>              : cache set not found
>=20
> but maybe warn in the manual/wiki
>=20
>=20
> On 2023/08/11 21:19, Josias Wolhuter wrote:
>> Hi
>> Sorry to bug you (pun intended)
>> I get this
>> [root@ivan ~]# echo b43b13cf-32b1-4e5a-af7d-27b6d246662d  =
>/sys/block/bcache0/bcache/attach
>> -bash: echo: write error: No such file or directory
>> but
>> bcache-super-show /dev/nvme1n1p1
>> ***
>> cset.uuid        b43b13cf-32b1-4e5a-af7d-27b6d246662d
>> bcache-super-show /dev/sdb1
>> ***
>> dev.data.cache_state    0 [detached]
>> cset.uuid        00000000-0000-0000-0000-000000000000
>> One unusual thing I did was to set the cache device block size =
differently/seperately from the backing device.  but dont see mention of =
such a difference in the manual or online
>> Cheers


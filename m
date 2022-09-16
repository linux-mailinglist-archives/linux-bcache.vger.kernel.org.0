Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71195BB115
	for <lists+linux-bcache@lfdr.de>; Fri, 16 Sep 2022 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIPQ3F (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 16 Sep 2022 12:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiIPQ3D (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2022 12:29:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD476A6C5C
        for <linux-bcache@vger.kernel.org>; Fri, 16 Sep 2022 09:29:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DE31833764;
        Fri, 16 Sep 2022 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663345739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NEMlRS9UPvG++Q5j5KUWxB/fTWa/XUov0/IvP0frq5M=;
        b=Pb4JAmCnCoxN/HVCo/gh579jB6/QiIOu3WfryYzVvkMy2TswEL6qSiWzjqxfjFWSD5Naaf
        q4tqANEoy0VVsTMvToyAfb7gjDi4DuD11Z7kMEDeS1CL9RD5NgDRp+2V+Kbac2JB+7d2DY
        YLyJYHWX1JqgnbGlrUeNCa4Sk2qlq0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663345739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NEMlRS9UPvG++Q5j5KUWxB/fTWa/XUov0/IvP0frq5M=;
        b=0KiaU5Gx9g0OTY7XNmNTjtO99QOqfsMD7iwyveY7awrOjp8yrz0vBJUTw/1ZTWLi9kCiJ0
        2Sv3vbGdMwIsWeDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D00A21332E;
        Fri, 16 Sep 2022 16:28:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UjszJEqkJGMmBQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 16 Sep 2022 16:28:58 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: set cool backing device to maximum writeback rate
From:   Coly Li <colyli@suse.de>
In-Reply-To: <d806a566-446a-1649-3621-edd66a629f69@easystack.cn>
Date:   Sat, 17 Sep 2022 00:28:55 +0800
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A1D6854-B60D-4A00-AA30-80BB8C376885@suse.de>
References: <20220915120544.9086-1-mingzhe.zou@easystack.cn>
 <993D46BB-D0BF-499C-B8B3-89405DD1DB66@suse.de>
 <d806a566-446a-1649-3621-edd66a629f69@easystack.cn>
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8816=E6=97=A5 15:10=EF=BC=8CZou Mingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
> =E5=9C=A8 2022/9/15 22:44, Coly Li =E5=86=99=E9=81=93:
>>> 2022=E5=B9=B49=E6=9C=8815=E6=97=A5 20:05=EF=BC=8Cmingzhe.zou@easystack=
.cn =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> From: mingzhe <mingzhe.zou@easystack.cn>
>>>=20
>>> If the data in the cache is dirty, gc thread cannot reclaim the =
space.
>>> We need to writeback dirty data to backing, and then gc can reclaim
>>> this area. So bcache will writeback dirty data more aggressively.
>>>=20
>> The writeback operation should try to avoid negative influence to =
front end I/O performance. Especially the I/O latency.
>>> Currently, there is no io request within 30 seconds of the =
cache_set,
>>> all backing devices in it will be set to the maximum writeback rate.
>> The idle time depends how many backing devices there are. If there is =
1 backing device, the idle time before maximum writeback rate setting is =
30 seconds, if there are 2 backing device, the idle time will be 60 =
seconds. If there are 6 backing device attached with a cache set, the =
maximum writeback rate will be set after 180 seconds without any =
incoming I/O request. That is to say, the maximum writeback rate setting =
is not a aggressive writeback policy, it is just try to writeback more =
dirty data without interfering regular I/O request when the cache set is =
really idle.
> The idle time does not depend on how many backing devices there are. =
Although the threshold of c->idle_counter is c->attached_dev_nr * 6, =
each backing device has its own writeback thread. If all backing devices =
are in writeback mode (writeback_percent is not 0) , it should be fixed =
for 30 seconds.


I think you catch a bug in set_at_max_writeback_rate(). The correct =
calculation should be,
       if ((counter / dev_nr) < (dev_nr * 6))
                return false;

The fix patch will be posted and Cc you soon, after it is tested.

Thanks.

Coly Li=

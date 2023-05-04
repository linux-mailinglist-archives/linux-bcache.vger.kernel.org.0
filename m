Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F926F642A
	for <lists+linux-bcache@lfdr.de>; Thu,  4 May 2023 06:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjEDE4Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 May 2023 00:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjEDE4Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2023 00:56:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB43199E
        for <linux-bcache@vger.kernel.org>; Wed,  3 May 2023 21:56:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 27D972012D;
        Thu,  4 May 2023 04:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683176181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0ob948yio829w1hiAmzFat6tlr0M8yDU06J4NgnktU=;
        b=yNb8I3D7unU+jqciE7o53XPMeJpqXOCLnNM9BRmQko9R/GHS+auZUf22wBkFc0TLmDJHP6
        L9G0C2dhvBc1Hd9lHBW3lLK6IzMsfSRL0jVwQH63k3bCufjY4knFp1DLCCGTsD0IBQsFjQ
        dIQcihb90U51qqw6FKMLLJHPSYVX7QQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683176181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0ob948yio829w1hiAmzFat6tlr0M8yDU06J4NgnktU=;
        b=FWCsJNxAy2qqV31ohV0aE83aulQZMQteARvLLiFgbV7Kzq2e65EgwCkO4z91jXutRxPeC/
        2telo/j5nEG7aiBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1FE3013584;
        Thu,  4 May 2023 04:56:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id okRjN/M6U2RnRwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 04 May 2023 04:56:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Writeback cache all used.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net>
Date:   Thu, 4 May 2023 12:56:07 +0800
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
 <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
 <1121771993.1793905.1680221827127@mail.yahoo.com>
 <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
 <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
 <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
 <1783117292.2943582.1680640140702@mail.yahoo.com>
 <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com>
 <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de>
 <1806824772.518963.1681071297025@mail.yahoo.com>
 <125091407.524221.1681074461490@mail.yahoo.com>
 <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=883=E6=97=A5 04:34=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, 20 Apr 2023, Adriano Silva wrote:
>> I continue to investigate the situation. There is actually a =
performance=20
>> gain when the bcache device is only half filled versus full. There is =
a=20
>> reduction and greater stability in the latency of direct writes and =
this=20
>> improves my scenario.
>=20
> Hi Coly, have you been able to look at this?
>=20
> This sounds like a great optimization and Adriano is in a place to =
test=20
> this now and report his findings.
>=20
> I think you said this should be a simple hack to add early reclaim, so=20=

> maybe you can throw a quick patch together (even a rough first-pass =
with=20
> hard-coded reclaim values)
>=20
> If we can get back to Adriano quickly then he can test while he has an=20=

> easy-to-reproduce environment.  Indeed, this could benefit all bcache=20=

> users.

My current to-do list on hand is a little bit long. Yes I=E2=80=99d like =
and plan to do it, but the response time cannot be estimated.

Coly Li

[snipped]=

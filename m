Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6DF687FBF
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjBBOSj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 09:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjBBOSi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 09:18:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F1A7AE6F;
        Thu,  2 Feb 2023 06:18:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2CD7A1FEEB;
        Thu,  2 Feb 2023 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675347515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuBytfG1w6BPzKsvX88iJxCnFAyql/AZw50tfrDxgNw=;
        b=Or3oKyrYUwWtk6jkOhRTySQPprYtieCo+DTYN7+iv9PwNm43/uQqVWbqdvEbJdZ89dVPef
        qQRUkJOm+DOkOOHI9rvjH1qp7Wcfx986S/p1KTjZNscaouo/21oqEQyiwUTQu2O044QfDi
        qPgJACgxIgN7rB9Uugw1+1lYP6T5j3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675347515;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuBytfG1w6BPzKsvX88iJxCnFAyql/AZw50tfrDxgNw=;
        b=mIzmLfn6+WZQRSubEJ5+geyg12LcG02wOcCSfBGhbH9oriRfOjbRIwI4kPMEj+Jfc2Uc4u
        AOES6DaWpPLliNBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 045F1139D0;
        Thu,  2 Feb 2023 14:18:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IYrGLjjG22ONRwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 02 Feb 2023 14:18:32 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_split
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAJedcCxWcyvzTWG2sZquGXO92qH=yV_wjaU0WtXpVT=SC13wbw@mail.gmail.com>
Date:   Thu, 2 Feb 2023 22:18:18 +0800
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alex000young@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CEE564CA-A779-437D-B38B-FAF9F6957771@suse.de>
References: <20230202110543.27548-1-zyytlz.wz@163.com>
 <50656A90-E0D4-4800-880C-406EBDD784FC@suse.de>
 <CAJedcCxWcyvzTWG2sZquGXO92qH=yV_wjaU0WtXpVT=SC13wbw@mail.gmail.com>
To:     Zheng Hacker <hackerzheng666@gmail.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=882=E6=97=A5 22:11=EF=BC=8CZheng Hacker =
<hackerzheng666@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Coly Li <colyli@suse.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=882=E6=97=A5=E5=91=
=A8=E5=9B=9B 20:22=E5=86=99=E9=81=93=EF=BC=9A
>=20
>> Hmm, there should be something to be fixed, but not the non-exist =
NULL dereference.
>>=20
>> If you look inside btree_node_alloc_replacement(), you may find =
__bch_btree_node_alloc() which does the real work indeed. And yes, I =
would suggest you to improve a bit inside __bch_btree_node_alloc().
>>=20
>> 1088 struct btree *__bch_btree_node_alloc(struct cache_set *c, struct =
btree_op *op,
>> [snipped]
>> 1093         struct btree *b =3D ERR_PTR(-EAGAIN);
>> 1094
>> 1095         mutex_lock(&c->bucket_lock);
>> 1096 retry:
>> 1097         if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, =
wait))
>> 1098                 goto err;
>> [snipped]
>> 1102
>> 1103         b =3D mca_alloc(c, op, &k.key, level);
>> 1104         if (IS_ERR(b))
>> 1105                 goto err_free;
>> 1106
>> 1107         if (!b) {
>> 1108                 cache_bug(c,
>> 1109                         "Tried to allocate bucket that was in =
btree cache");
>> 1110                 goto retry;
>> 1111         }
>> 1112
>>=20
>> =46rom the above code, at line 1097 if __bch_bucket_alloc_set() =
returns non-zero value, the code will jump to label err: and returns =
ERR_PTR(-EAGAIN). But if the code fails at line 1103 and b is set to =
NULL, at line 1110 the code will jump back to label retry: and calls =
__bch_bucket_alloc_set() again. If the second time =
__bch_bucket_alloc_set() returns non-zero value and the code jumps to =
label err:, a NULL pointer other than ERR_PTR(-EAGAIN) will be returned. =
This inconsistent return value on same location at line 1097 seems =
incorrect, where ERR_PTR(-EAGAIN) should be returned IMHO.
>>=20
>> Therefore I feel that =E2=80=9Cb =3D ERR_PTR(-EAGAIN)=E2=80=9D should =
be moved to the location after label retry:, then =
btree_node_alloc_replacement() will only return error code, and no NULL =
pointer returned.
>>=20
>> After this change, all following IS_ERR_OR_NULL() checks to =
btree_node_alloc_replacement() are unnecessary and IS_ERR() just enough, =
because no NULL will be returned.
>>=20
>> This is a nice catch. I=E2=80=99d like to have it to be fixed. I do =
appreciate if you want to compose two patches for the fix. Otherwise I =
can handle it myself.
>>=20
> Hi Coly,
>=20
> Thanks for your reply and detailed explaination! As you explain, I
> found __bch_btree_node_alloc may return NULL in some situation. So I
> add some more check in upper code.
> Your suggestion is more constructive. It'll make the function more
> clear for other developer. I'd like to help with the patch. And you
> have kindly pointed the right way to fix.
> May I merge fix it in one patch with the commit msg "refactor
> __bch_btree_node_alloc to avoid poential NULL dereference"? Because I
> think if __bch_btree_node_alloc returns
> NULL to bch_btree_node_alloc, the function
> btree_node_alloc_replacement will strill return NULL to n1 in
> btree_split. I think the possibility is low, if it's not proper,
> please feel free
> to let me know.

This is not a refactor indeed, just a simple fix to =
__bch_btree_node_alloc() to make the failure behavior of calling =
__bch_bucket_alloc_set() at line 1097 to be consistent. A.K.A always =
returning ERR_PTR(-EAGAIN) when it returns failure.

Another optional patch is to change the unnecessary IS_ERR_OR_NULL() to =
IS_ERR() in proper locations, because after the first fix, NULL won=E2=80=99=
t be returned indeed. And extra code comments on why IS_ERR() is =
sufficient might be preferred IMHO.

Thanks.

Coly Li


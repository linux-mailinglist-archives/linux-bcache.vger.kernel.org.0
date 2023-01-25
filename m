Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA067B8EC
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Jan 2023 19:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbjAYSAC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 Jan 2023 13:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbjAYSAB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Jan 2023 13:00:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D13C2B1
        for <linux-bcache@vger.kernel.org>; Wed, 25 Jan 2023 09:59:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 533F921D85;
        Wed, 25 Jan 2023 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674669598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDVpZIujHBrMLdBqPbTJkD40N3IMxVoOKeR0UJGRxZ0=;
        b=arJhPLancqmWgMT9Btv+EZxnoZrefXIWEIBOp61wVXpNSurls4ZhiXX5NulJMmQSJdwEJe
        RcHZdMSOCXAGlZ9Z80MJVa0IXHjNg0iPLNaP9CeNmzipJbWJq1fhvw4lOJTV0A0+x4mLPq
        pTSXyFhQ5hiqIu/NLVWDCwgNMOMF9ag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674669598;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDVpZIujHBrMLdBqPbTJkD40N3IMxVoOKeR0UJGRxZ0=;
        b=1l+ppvBRCNNvj9w9/d2S+J46oYn58fJqCU4PHMFkDSWVBDGgfdGhEGtyk02R+HZfTFqAji
        a3q9aWX2ex0i9NDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C9D01339E;
        Wed, 25 Jan 2023 17:59:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id buDKAh1u0WNDPwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 25 Jan 2023 17:59:57 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
Date:   Thu, 26 Jan 2023 01:59:44 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
 <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
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



> 2023=E5=B9=B41=E6=9C=8825=E6=97=A5 18:07=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Jan 17, 2023 at 5:18 PM Coly Li <colyli@suse.de> wrote:
>>>=20

>>>>=20
>>>>> struct async_reg_args {
>>>>>    struct delayed_work reg_work;
>>>>>    char *path;
>>>>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct =
kobject
>>>>> *k, struct kobj_attribute *attr,
>>>>>            mutex_lock(&bch_register_lock);
>>>>>            if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
>>>>>                bch_is_open(dev))
>>>>> -                err =3D "device already registered";
>>>>> +                if (bch_update_capacity(dev))
>>>>> +                    err =3D "capacity changed";
>>>>> +                else
>>>>> +                    err =3D "device already registered";
>>>>=20
>>>>=20
>>>> As I said, it should be a separated write-only sysfile under the =
cache
>>>> device's directory.
>>> Can I ask why you don't like the automatic resize way? Why should =
the
>>> resize be manual?
>>=20
>> Most of system administrators don=E2=80=99t like such silently =
automatic things. They want to extend the size explicitly, especially =
when there is other dependences in their configurations.
>>=20
> What I was trying to say is that, in order to resize a block device, a
> manual command should be executed. So, this is already a "non-silent"
> automatic thing.
> Moreover, if the block device has a FS on it, the FS needs to be
> manually grown with some special utilities, e.g. xfs_growfs. So,
> again, another non-silent automatic step. Don't you agree?
> For example, to resize a qcow device attached to a VM I'm manually
> doing a `virsh blockresize`. As soon as I issue that command, the
> virtio_blk driver inside the VM detects the disk size change and calls
> the `set_capacity_and_notify` function. Why then should bcache behave
> differently?

The above VM example makes sense, I am almost convinced.

>=20
> If you're concerned that this can somehow break the
> behaviour-compatibility with older versions of the driver, can we
> protect this automatic discovery with an optional parameter? Will this
> be an option you will take into account?

Then let=E2=80=99s forget the option sysfs at this moment. Once you feel =
the patch is ready for me to testing, please notice me with detailed =
steps to redo your testing.
At that time during my testing, let=E2=80=99s discuss whether an extra =
option is necesssary, for now just keep your idea as automatically =
resize the cached device.

Thanks for your detailed explanation.

Coly Li


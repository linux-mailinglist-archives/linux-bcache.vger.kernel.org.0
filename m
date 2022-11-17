Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7F62D805
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Nov 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiKQKaQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Nov 2022 05:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiKQKaQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Nov 2022 05:30:16 -0500
Received: from FML-ESSALUD.essalud.gob.pe (fml-essalud.essalud.gob.pe [190.81.44.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E5059173
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 02:30:13 -0800 (PST)
Received: from mail.essalud.gob.pe ([172.20.0.227])
        by FML-ESSALUD.essalud.gob.pe  with ESMTP id 2AHAU6LB032424-2AHAU6LK032424
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 05:30:11 -0500
Received: from correo.essalud.gob.pe (mail.essaludperu.pe [10.0.1.43])
        by mail.essalud.gob.pe (Postfix on SuSE Linux 7.2 (i386)) with ESMTP id EBF7766CC84
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 05:35:40 -0500 (PET)
Received: from localhost (localhost [127.0.0.1])
        by correo.essalud.gob.pe (Postfix) with ESMTP id 2F24E6741E5C9
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 05:24:16 -0500 (-05)
Received: from correo.essalud.gob.pe ([127.0.0.1])
        by localhost (correo.essalud.gob.pe [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id M94xriVV1wmy for <linux-bcache@vger.kernel.org>;
        Thu, 17 Nov 2022 05:24:16 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by correo.essalud.gob.pe (Postfix) with ESMTP id E793E6741E5F8
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 05:24:15 -0500 (-05)
DKIM-Filter: OpenDKIM Filter v2.10.3 correo.essalud.gob.pe E793E6741E5F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=essalud.gob.pe;
        s=0C7340B8-402B-11ED-89C3-99F5FC01023F; t=1668680655;
        bh=uY+KPOQWlDhrVS4T9GmWZxPLHRTXQCu8TOIV7Ic88Ug=;
        h=To:Date:Message-ID:MIME-Version:From;
        b=vp3BuPlDIugxz5Af0XgticlA5P+tartjRGeu+sAXoYJEgQh6M44EQnZVNP6ZaBQUU
         Uez3LCnhINZca9QKLaUrmT/HYKwGkAnB1loeM3gjAA88yRLRnDaYhsY6Hi5T40gXux
         zS2T7gi2c8MbRkcLu0jg5ab3RxolKudv+sNDgGgOOIUQw8mYD5hPNUbbbkG+wAsrPS
         35IWbT/23inqXU4NX+Ec6t6sLBH0VUbDbDFI4UYeJAFexZD7/2w4mMsFQHvN7MX70i
         NZsJMBIHfM2OYGyKcPAnXWJ0WKTc4sG8O3bZLWT9/OsEZZysL3WQir1vOxTXIjMre7
         VSNsiSEx5LmaA==
X-Virus-Scanned: amavisd-new at essalud.gob.pe
Received: from correo.essalud.gob.pe ([127.0.0.1])
        by localhost (correo.essalud.gob.pe [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Nm0PDJ1VpE88 for <linux-bcache@vger.kernel.org>;
        Thu, 17 Nov 2022 05:24:15 -0500 (-05)
Received: from [200.25.45.234] (unknown [200.25.45.232])
        by correo.essalud.gob.pe (Postfix) with ESMTPSA id 3EAF76741E5FE
        for <linux-bcache@vger.kernel.org>; Thu, 17 Nov 2022 05:24:15 -0500 (-05)
Reply-To: sergei.lai58@gmail.com
To:     linux-bcache@vger.kernel.org
Subject: =?UTF-8?B?ZGllIEluZm8gLTM1ICUgZ2Vow7ZyZW4gSWhuZW4=?=
Date:   17 Nov 2022 10:30:10 +0000
Message-ID: <20221117103009.37B0928A47EDBB7F@from.header.has.no.domain>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From:   juan.aguilarve@essalud.gob.pe
X-FEAS-DKIM: Invalid Public Key
Authentication-Results: fml-essalud.essalud.gob.pe;
        dkim=neutral (Could not retrieve key) header.i=@essalud.gob.pe
X-FE-Policy-ID: 2:2:2:essalud.gob.pe
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        NIXSPAM_IXHASH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5783]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sergei.lai58[at]gmail.com]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [190.81.44.152 listed in wl.mailspike.net]
        *  3.0 NIXSPAM_IXHASH http://www.nixspam.org/
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Bitte ich brauche Ihre Hilfe, um $50 000 000.00 aus einem=20
sicheren Safe zu bewegen.

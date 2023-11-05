Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229AA7E1701
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Nov 2023 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjKEV7Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Nov 2023 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjKEV7Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Nov 2023 16:59:24 -0500
X-Greylist: delayed 5162 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Nov 2023 13:59:21 PST
Received: from SMTP-HCRC-200.brggroup.vn (unknown [42.112.212.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B15BF
        for <linux-bcache@vger.kernel.org>; Sun,  5 Nov 2023 13:59:21 -0800 (PST)
Received: from SMTP-HCRC-200.brggroup.vn (localhost [127.0.0.1])
        by SMTP-HCRC-200.brggroup.vn (SMTP-CTTV) with ESMTP id 869DC18FE3;
        Mon,  6 Nov 2023 01:57:40 +0700 (+07)
Received: from zimbra.hcrc.vn (unknown [192.168.200.66])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by SMTP-HCRC-200.brggroup.vn (SMTP-CTTV) with ESMTPS id 7FCE7190EF;
        Mon,  6 Nov 2023 01:57:40 +0700 (+07)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.hcrc.vn (Postfix) with ESMTP id 161571B81FC6;
        Mon,  6 Nov 2023 01:57:42 +0700 (+07)
Received: from zimbra.hcrc.vn ([127.0.0.1])
        by localhost (zimbra.hcrc.vn [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id gGdTGx4uPr1N; Mon,  6 Nov 2023 01:57:41 +0700 (+07)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.hcrc.vn (Postfix) with ESMTP id D69501B82538;
        Mon,  6 Nov 2023 01:57:41 +0700 (+07)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.hcrc.vn D69501B82538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hcrc.vn;
        s=64D43D38-C7D6-11ED-8EFE-0027945F1BFA; t=1699210661;
        bh=WOZURJ77pkiMUL2pPLC14ifVPRvyTQIBEQmxuN1ezAA=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=wCwf7LBoaGTZ9VB2EK+yvrkecq2fYviMeFOzAHv1FZ7+uylxe9jEUWYD2gRuhJEJn
         8xbNuruob2iMN4nMnLB1wmF9eJ4CsUuplNyipuUAyG8vI20sobHxVHPDQmNSSGtj5W
         MY0WjGUyzMAKEylwvsSuSNAfT+A8jNIWpGL/zDOq17rtAeioetp6YSkGXkQNVOJcJ5
         ZDMDfvLtGPyjVKyupNVPb6q9qyjqpl/I23HEGIAu1xJW5IAL8yTIi9lAWpxjUE1ouw
         FGD0RS0ISiYDX0OBRR0cx7jVyY8VRDq3gkEIMoELoU5m0Nfhbl3mYvl5By1LNdu3eK
         rH5SzNmapZxXg==
X-Virus-Scanned: amavisd-new at hcrc.vn
Received: from zimbra.hcrc.vn ([127.0.0.1])
        by localhost (zimbra.hcrc.vn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wv1Tj3lGJK9p; Mon,  6 Nov 2023 01:57:41 +0700 (+07)
Received: from [192.168.1.152] (unknown [51.179.100.52])
        by zimbra.hcrc.vn (Postfix) with ESMTPSA id 890921B8203A;
        Mon,  6 Nov 2023 01:57:35 +0700 (+07)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?b?4oKsIDEwMC4wMDAuMDAwPw==?=
To:     Recipients <ch.31hamnghi@hcrc.vn>
From:   ch.31hamnghi@hcrc.vn
Date:   Sun, 05 Nov 2023 19:57:25 +0100
Reply-To: joliushk@gmail.com
Message-Id: <20231105185735.890921B8203A@zimbra.hcrc.vn>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Goededag,
Ik ben mevrouw Joanna Liu en een medewerker van Citi Bank Hong Kong.
Kan ik =E2=82=AC 100.000.000 aan u overmaken? Kan ik je vertrouwen


Ik wacht op jullie reacties
Met vriendelijke groeten
mevrouw Joanna Liu

